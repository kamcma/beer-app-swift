import Vapor
import VaporPostgreSQL
import Fluent
import HTTP

public func setup(_ drop: Droplet) throws {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
    drop.preparations = [Brewery.self, Beer.self, User.self]

    AdminController(drop: drop).addRoutes()
    UserController(drop: drop).addRoutes()
}
