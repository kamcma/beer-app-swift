import Vapor
import VaporPostgreSQL
import Auth

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations = [Brewery.self, Beer.self, User.self]

drop.middleware.append(AuthMiddleware(user: User.self))

AdminController().addRoutes(drop: drop)
UserController().addRoutes(drop: drop)
drop.get("/") { _ in
    return try drop.view.make("index")
}

drop.run()
