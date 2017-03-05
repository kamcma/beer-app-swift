import Vapor
import VaporPostgreSQL
import Auth

public func setup(_ drop: Droplet) throws {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
    drop.preparations = [Brewery.self, Beer.self, User.self]

    drop.middleware.append(AuthMiddleware(user: User.self))

    AdminController(drop: drop).addRoutes()
    UserController(drop: drop).addRoutes()
    BreweryController(drop: drop).addRoutes()

    drop.get("/") { _ in
        return try drop.view.make("index")
    }
}
