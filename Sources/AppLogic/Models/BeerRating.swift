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
        self.stars = stars
        self.userId = userId
        self.beerId = beerId
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        stars = try node.extract("stars")
        userId = try node.extract("user_id")
        beerId = try node.extract("beer_id")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "stars": stars,
            "user_id": userId,
            "beer_id": beerId
        ])
    }

    static func prepare (_ database: Database) throws {
        throw Abort.badRequest
    }

    static func revert (_ database: Database) throws {
        throw Abort.badRequest
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
