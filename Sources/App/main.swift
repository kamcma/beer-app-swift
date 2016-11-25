import Vapor
import VaporPostgreSQL

let drop = Droplet(
    preparations: [Brewery.self, Beer.self],
    providers: [VaporPostgreSQL.Provider.self]
)

drop.get("version") {request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("select version()")
        return try JSON(node: version)
    } else {
        return "No db connection"
    }
}

drop.get("breweries") { request in
    return "Not yet implemented"
}

drop.get("beers") { request in
    return "Not yet implemented"
}

drop.run()
