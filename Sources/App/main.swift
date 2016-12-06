import Vapor
import VaporPostgreSQL
import VaporMemory

let drop = Droplet(
    preparations: [Brewery.self, Beer.self],
    providers: [VaporPostgreSQL.Provider.self]
)

if drop.environment == .production {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} else {
    try drop.addProvider(VaporMemory.Provider.self)
}


drop.get("brewery") { request in
    var brewery = Brewery(name: "Great Lakes Brewing Company")
    try brewery.save()
    return try JSON(node: Brewery.all().makeNode())
}


drop.run()
