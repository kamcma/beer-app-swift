import Vapor
import Fluent

final class Beer: Model {
    var id: Node?
    var exists: Bool = false

    var name: String
    var slug: String
    var breweryId: Node?
    var abv: Double

    init(name: String, slug: String, breweryId: Node? = nil, abv: Double) {
        self.id = nil
        self.name = name
        self.slug = slug
        self.breweryId = breweryId
        self.abv = abv
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        slug = try node.extract("slug")
        breweryId = try node.extract("brewery_id")
        abv = try node.extract("abv")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "slug": slug,
            "brewery_id": breweryId,
            "abv": abv
        ])
    }

    static func prepare (_ database: Database) throws {
        try database.create(entity) { beers in
            beers.id()
            beers.string("name")
            beers.string("slug")
            beers.parent(Brewery.self, optional: false)
            beers.double("abv")
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
