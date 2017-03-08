import Vapor
import VaporPostgreSQL
import Auth

public func setup(_ drop: Droplet) throws {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
    drop.preparations = [M20170307185700InitialMigration.self]
    drop.commands.append(Seed(console: drop.console))

    drop.middleware.append(AuthMiddleware(user: User.self))

    AdminController(drop: drop).addRoutes()
    UserController(drop: drop).addRoutes()
    BreweryController(drop: drop).addRoutes()

    drop.get("/") { _ in
        return try drop.view.make("index")
    }
}
