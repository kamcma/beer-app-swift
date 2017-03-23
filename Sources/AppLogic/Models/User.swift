import Vapor
import Fluent
import Turnstile
import TurnstileCrypto
import Auth

final class User: Auth.User {
    var exists: Bool = false
    var id: Node?
    var email: Valid<Email>
    var password: String
    var firstName: String
    var lastName: String
    var admin: Bool

    init (credentials: UsernamePassword, firstName: String, lastName: String, admin: Bool = false) throws {
        self.email = try credentials.username.validated()
        self.password = BCrypt.hash(password: credentials.password)
        self.firstName = firstName
        self.lastName = lastName
        self.admin = admin
    }

    init (node: Node, in context: Context) throws {
        id = node["id"]
        let emailString = try node.extract("email") as String
        email = try emailString.validated()
        password = try node.extract("password") as String
        firstName = try node.extract("first_name") as String
        lastName = try node.extract("last_name") as String
        admin = try node.extract("admin") as Bool ?? false
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "email": email.value,
            "password": password,
            "first_name": firstName,
            "last_name": lastName,
            "admin": admin
        ])
    }

    static func authenticate(credentials: Credentials) throws -> Auth.User {
        var user: User?

        switch credentials {
        case let credentials as UsernamePassword:
            let fetchedUser = try User.query()
                .filter("email", credentials.username).first()
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

    static func register(credentials: Credentials, firstName: String, lastName: String) throws -> Auth.User {
        var newUser: User

        switch credentials {
        case let credentials as UsernamePassword:
            newUser = try User(credentials: credentials, firstName: firstName, lastName: lastName)
        default:
            throw UnsupportedCredentialsError()
        }

        if try User.query().filter("email", newUser.email.value).first() == nil {
            try newUser.save()
            return newUser
        } else {
            throw AccountTakenError()
        }
    }

    static func prepare(_ database: Database) throws { }

    static func revert(_ database: Database) throws { }
}

extension User {
    func beerRatings() throws -> Children<BeerRating> {
        return children()
    }
}
