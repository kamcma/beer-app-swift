import Vapor
import Fluent

final class Beer: Model {
    var id: Node?
    var exists: Bool = false

    var name: String
    var breweryId: Node?

    init(name: String, breweryId: Node? = nil) {
        self.id = nil
        self.name = name
        self.breweryId = breweryId
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        breweryId = try node.extract("brewery_id")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "brewery_id": breweryId
        ])
    }

    static func prepare (_ database: Database) throws {
        try database.create(entity) { beers in
            beers.id()
            beers.string("name")
            beers.parent(Brewery.self, optional: false)
        }
    }

    static func revert (_ database: Database) throws {
        try database.delete(entity)
    }
}

//convenience methods

extension Beer {
    func brewery() throws -> Parent<Brewery> {
        return try parent(breweryId)
    }
}
