import Vapor
import Fluent

final class BeerRating: Model {
    var id: Node?
    var exists: Bool = false

    var userId: Node?
    var beerId: Node?
    var thumbUp: Bool

    init(thumbUp: Bool, userId: Node? = nil, beerId: Node? = nil) {
        self.id = nil
        self.thumbUp = thumbUp
        self.userId = userId
        self.beerId = beerId
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        userId = try node.extract("user_id")
        beerId = try node.extract("beer_id")
        thumbUp = try node.extract("thumb_up")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "user_id": userId,
            "beer_id": beerId,
            "thumb_up": thumbUp
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
