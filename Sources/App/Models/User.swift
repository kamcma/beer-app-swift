import Vapor
import Fluent
import Turnstile
import TurnstileCrypto

final class User: Model {
    var exists: Bool = false
    var id: Node?
    var name: Valid<NameValidator>
    var email: Valid<Email>
    var password: String

    init (name: String, email: String, rawPassword: String) throws {
        self.name = try name.validated()
        self.email = try email.validated()
        let validatedPassword: Valid<PasswordValidator> = try rawPassword.validated()
        self.password = BCrypt.hash(password: validatedPassword.value)
    }

    init (node: Node, in context: Context) throws {
        id = node["id"]
        let nameString = try node.extract("name") as String
        name = try nameString.validated()
        let emailString = try node.extract("email") as String
        email = try emailString.validated()
        let passwordString = try node.extract("password") as String
        password = passwordString
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name.value,
            "email": email.value,
            "password": password
        ])
    }

    static func prepare(_ database: Database) throws {
        try database.create("users") {users in
            users.id()
            users.string("name")
            users.string("email")
            users.string("password")

        }
    }

    static func revert(_ database: Database) throws {
        try database.delete("users")
    }

    static func register(name: String, email: String, rawPassword: String) throws -> User {
        var newUser = try User(name: name, email: email, rawPassword: rawPassword)
        if try User.query().filter("email", newUser.email.value).first() == nil {
            try newUser.save()
            return newUser
        } else {
            throw AccountTakenError()
        }
    }
}

import Auth

extension User: Auth.User, Authenticator {
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        var user: User?

        switch credentials {
            case let credentials as UsernamePassword:
                let fetchedUser = try User.query()
                    .filter("email", credentials.username)
                    .first()
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
        throw Abort.badRequest
    }
}
