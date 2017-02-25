import Vapor
import Fluent

final class BeerRating: Model {
    var id: Node?
    var exists: Bool = false

    var stars: Int
    var userId: Node?
    var beerId: Node?

    init(stars: Int, userId: Node? = nil, beerId: Node? = nil) {
        self.id = nil
        self.userId = userId
        self.beerId = beerId
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        userId = try node.extract("user_id")
        beerId = try node.extract("beer_id")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "user_id": user_id,
            "beer_id": beer_id
        ])
    }

    static func prepare (_ database: database) throws {
        try database.create(entity) { beerRatings in
            beerRatings.id()
            beerRatings.parent(User.self, optional: false)
            beerRatings.parent(Beer.self, optional: false)
        }
    }
}

//convenience methods

extension BeerRating {
    func user() throws -> Parent<User> {
        return try parent(userId)
    }

    func beer() throws -> Parent<Beer> {
        return try parent(beerId)
    }
}
