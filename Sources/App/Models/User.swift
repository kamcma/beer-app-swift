import Vapor
import Fluent
import Turnstile
import TurnstileCrypto
import Auth

final class User: Auth.User {
    var exists: Bool = false
    var id: Node?
    var username: String
    var password: String

    init (credentials: UsernamePassword) {
        self.username = credentials.username
        self.password = BCrypt.hash(password: credentials.password)
    }

    init (node: Node, in context: Context) throws {
        id = node["id"]
        username = try node.extract("username") as String
        password = try node.extract("password") as String

    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "username": username,
            "password": password
        ])
    }

    static func authenticate(credentials: Credentials) throws -> Auth.User {
        var user: User?

        switch credentials {
        case let credentials as UsernamePassword:
            let fetchedUser = try User.query()
                .filter("username", credentials.username).first()
            if let password = fetchedUser?.password, password != "",
                (try? BCrypt.verify(password: credentials.password, matchesHash: password)) == true {
                user = fetchedUser
            }
        case let credentials as Identifier:
            user = try User.find(credentials.id)
        default:
            throw UnsupportedCredentialsError()
        }

        if let user = user {
            return user
        } else {
            throw IncorrectCredentialsError()
        }
    }

    static func register(credentials: Credentials) throws -> Auth.User {
        var newUser: User

        switch credentials {
        case let credentials as UsernamePassword:
            newUser = User(credentials: credentials)
        default:
            throw UnsupportedCredentialsError()
        }

        if try User.query().filter("username", newUser.username).first() == nil {
            try newUser.save()
            return newUser
        } else {
            throw AccountTakenError()
        }
    }

    static func prepare(_ database: Database) throws {
        try database.create("users") {users in
            users.id()
            users.string("username")
            users.string("password")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}
