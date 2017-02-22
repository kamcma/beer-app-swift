import Vapor
import HTTP
import VaporPostgreSQL

final class AdminController {
    func addRoutes(drop: Droplet) {
        drop.get("db", handler: testDbConnection)
    }

    func testDbConnection(request: Request) throws -> ResponseRepresentable {
        if let db = drop.database?.driver as? PostgreSQLDriver {
            let version = try db.raw("SELECT version()")
            return try JSON(node: version)
        } else {
            return "No db connection"
        }
    }
}
