import Vapor
import VaporPostgreSQL
import Fluent
import Auth
import Foundation
import Cookies
import XFPMiddleware

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

    drop.commands.append(Seed(drop: drop))

    drop.middleware.append(XFPMiddleware(enabled: drop.environment == .production))
    drop.middleware.append(AuthMiddleware(user: User.self) { value in
        return Cookie(
            name: "beer-app",
            value: value,
            expires: Date().addingTimeInterval(60 * 60 * 5),
            secure: drop.environment == .production
        )
    })

    AdminController(drop: drop).addRoutes()
    UserController(drop: drop).addRoutes()
    BreweryController(drop: drop).addRoutes()

    drop.get("/") { _ in
        return try drop.view.make("index")
    }
}
