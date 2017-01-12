import Vapor
import VaporPostgreSQL
import VaporMemory

let drop = Droplet()

if drop.environment == .production {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} else {
    try drop.addProvider(VaporMemory.Provider.self)
}

drop.preparations = [Brewery.self]

drop.get("breweries") { request in
    return try JSON(node: Brewery.query().sort("name", .ascending).all().makeNode())
}

drop.get("beers") {request in
    return try JSON(node: Beer.query().sort("name", .ascending).all().makeNode())
}

drop.run()