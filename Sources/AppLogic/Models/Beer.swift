import Vapor
import Fluent

final class Beer: Model {
    var id: Node?
    var exists: Bool = false

    var name: String
    var slug: String
    var breweryId: Node?
    var abv: Double?
    var ibu: Int?
    var active: Bool

    init(name: String, slug: String, brewery: Brewery, abv: Double? = nil, ibu: Int? = nil, active: Bool = false) {
        self.id = nil
        self.name = name
        self.slug = slug
        self.breweryId = brewery.id
        self.abv = abv
        self.ibu = ibu
        self.active = active
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        slug = try node.extract("slug")
        breweryId = try node.extract("brewery_id")
        abv = try node.extract("abv")
        ibu = try node.extract("ibu")
        active = try node.extract("active")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "slug": slug,
            "brewery_id": breweryId,
            "abv": abv,
            "ibu": ibu,
            "active": active
        ])
    }

    static func prepare (_ database: Database) throws { }

    static func revert (_ database: Database) throws { }
}

//convenience methods

extension Beer {
    func brewery() throws -> Parent<Brewery> {
        return try parent(breweryId)
    }
}
