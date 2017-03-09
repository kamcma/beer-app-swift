import Vapor
import VaporPostgreSQL
import Fluent
import Auth

public func setup(_ drop: Droplet) throws {
    try drop.addProvider(VaporPostgreSQL.Provider.self)

    let models: [Preparation.Type] = [
        User.self, Brewery.self, Beer.self, BeerRating.self
    ]
    let migrations: [Preparation.Type] = [
        M20170307185700InitialMigration.self
    ]

    for item in models + migrations {
        drop.preparations.append(item)
    }

    drop.middleware.append(AuthMiddleware(user: User.self))

    AdminController(drop: drop).addRoutes()
    UserController(drop: drop).addRoutes()
    BreweryController(drop: drop).addRoutes()

    drop.get("/") { _ in
        return try drop.view.make("index")
    }
}
