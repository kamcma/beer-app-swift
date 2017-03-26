import Vapor
import Console
import Fluent

final class Seed: Command {
    public let id = "seed"
    public let help = ["This command seeds the database."]
    public let console: ConsoleProtocol
    public let database: Database?

    public init(drop: Droplet) {
        self.console = drop.console
        self.database = drop.database
    }

    public func run(arguments: [String]) throws {
        console.print("Seeding the database ...")
        let seedBreweries = [
            Brewery(name: "Great Lakes Brewing Company", slug: "great-lakes", country: .unitedStates),
            Brewery(name: "Flying Dog Brewery", slug: "flying-dog", country: .unitedStates),
            Brewery(name: "Sierra Nevada Brewing Company", slug: "sierra-nevada", country: .unitedStates),
            Brewery(name: "Boston Beer Company", slug: "boston", country: .unitedStates),
            Brewery(name: "Lagunitas Brewing Company", slug: "lagunitas", country: .unitedStates),
            Brewery(name: "Bell's Brewery", slug: "bells", country: .unitedStates),
            Brewery(name: "Deschutes Brewery", slug: "deschutes", country: .unitedStates),
            Brewery(name: "Stone Brewing Company", slug: "stone", country: .unitedStates),
            Brewery(name: "Ballast Point Brewing Company", slug: "ballast-point", country: .unitedStates)
        ]
        for brewery in seedBreweries {
            brewery.active = true
        }
        try database?.seed(seedBreweries)

        console.print("Seeded the database.")
    }
}

extension Database {
    func seed<T: Entity, S: Sequence>(_ data: S) throws where S.Iterator.Element == T {
        let context = DatabaseContext(self)
        try data.forEach { model in
            let query = Query<T>(self)
            query.action = .create
            query.data = try model.makeNode(context: context)
            try driver.query(query)
        }
    }
}
