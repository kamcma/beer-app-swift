import Vapor
import Fluent

final class Brewery: Model {
    var id: Node?
    var exists: Bool = false
    static var entity = "breweries"

    var name: String
    var slug: String
    var country: Country?
    var active: Bool

    init(name: String, slug: String, country: Country? = nil, active: Bool = false) {
        self.id = nil
        self.name = name
        self.slug = slug.lowercased()
        self.country = country
        self.active = active
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        slug = try node.extract("slug")
        if let countryInt: Int = try node.extract("country") {
            country = Country(rawValue: countryInt)
        }
        active = try node.extract("active")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "slug": slug,
            "country": country?.rawValue,
            "active": active
        ])
    }

    static func prepare (_ database: Database) throws { }

    static func revert (_ database: Database) throws { }
}

//convenience methods

extension Brewery {
    func beers() -> Children<Beer> {
        return children()
    }
}
