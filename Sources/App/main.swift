import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
//drop.preparations = [Brewery.self]

AdminController().addRoutes(drop: drop)
UserController().addRoutes(drop: drop)

drop.run()
