import Vapor
import Fluent

final class BeerRating: Model {
    var id: Node?
    var exists: Bool = false

    var thumbUp: Bool
    var userId: Node?
    var beerId: Node?

    init(thumbUp: Bool, userId: Node? = nil, beerId: Node? = nil) {
        self.id = nil
        self.thumbUp = thumbUp
        self.userId = userId
        self.beerId = beerId
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        thumbUp = try node.extract("thumb_up")
        userId = try node.extract("user_id")
        beerId = try node.extract("beer_id")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "thumb_up": thumbUp,
            "user_id": userId,
            "beer_id": beerId
        ])
    }

    static func prepare (_ database: Database) throws { }

    static func revert (_ database: Database) throws { }
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
