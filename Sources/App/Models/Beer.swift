import Vapor
import Fluent

final class Beer: Model {
    var id: Node?
    var exists: Bool = false

    var name: String
    //var breweryId: Node?

    init(name: String) {
        self.id = nil
        self.name = name
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
        ])
    }

    static func prepare (_ database: Database) throws {
        try database.create("beers") { beers in
            beers.id()
            beers.string("name")
        }
    }

    static func revert (_ database: Database) throws {
        try database.delete("beers")
    }
}