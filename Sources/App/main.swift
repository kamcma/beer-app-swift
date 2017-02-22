import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)

drop.preparations = [Brewery.self]

drop.get("breweries") { _ in
    return try JSON(node: Brewery.query().sort("name", .ascending).all().makeNode())
}

drop.get("beers") { _ in
    return try JSON(node: Beer.query().sort("name", .ascending).all().makeNode())
}

drop.run()
