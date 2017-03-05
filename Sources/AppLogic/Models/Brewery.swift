import Vapor
import Fluent

final class Brewery: Model {
    var id: Node?
    var exists: Bool = false
    static var entity = "breweries"

    var name: String
    var slug: String

    init(name: String, slug: String) {
        self.id = nil
        self.name = name
        self.slug = slug.lowercased()
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        slug = try node.extract("slug")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "slug": slug
        ])
    }

    static func prepare (_ database: Database) throws {
        try database.create(entity) { breweries in
            breweries.id()
            breweries.string("name")
            breweries.string("slug")
        }
    }

    static func revert (_ database: Database) throws {
        try database.delete(entity)
    }
}

//convenience methods

extension Brewery {
    func beers() throws -> Children<Brewery> {
        return children()
    }
}
