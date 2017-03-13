import Vapor
import HTTP
import VaporPostgreSQL
import Turnstile
import Auth

final class UserController {
    let drop: Droplet

    init(drop: Droplet) {
        self.drop = drop
    }

    func addRoutes() {
        drop.get("register", handler: registerView)
        drop.post("register", handler: register)
        drop.get("login", handler: loginView)
        drop.post("login", handler: login)
        drop.get("account", handler: accountView)
        drop.get("logout", handler: logout)
    }

    func registerView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("register")
    }

    func loginView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("login")
    }

    func register(request: Request) throws -> ResponseRepresentable {
        guard let email = request.formURLEncoded?["email"]?.string,
            let password = request.formURLEncoded?["password"]?.string,
            let password2 = request.formURLEncoded?["password2"]?.string,
            let firstName = request.formURLEncoded?["first-name"]?.string,
            let lastName = request.formURLEncoded?["last-name"]?.string,
            password == password2 else {
                return try drop.view.make("register")
        }
        let credentials = UsernamePassword(username: email, password: password)

        do {
            try _ = User.register(credentials: credentials, firstName: firstName, lastName: lastName)
            try request.auth.login(credentials)
            return Response(redirect: "/account")
        } catch {
            return try drop.view.make("register")
        }
    }

    func login(request: Request) throws -> ResponseRepresentable {
        guard let email = request.formURLEncoded?["email"]?.string,
            let password = request.formURLEncoded?["password"]?.string else {
                return try drop.view.make("login")
        }

        let credentials = UsernamePassword(username: email, password: password)

        do {
            try request.auth.login(credentials)
            return Response(redirect: "/account")
        } catch {
            return try drop.view.make("login", ["error": "Invalid email or password"])
        }
    }

    func accountView(request: Request) throws -> ResponseRepresentable {
        guard let user = try? request.auth.user() else {
            return Response(redirect: "/login")
        }
        let parameters = try Node(node: [
            "authenticated": true,
            "user": user.makeNode()
        ])
        return try drop.view.make("account", parameters)
    }

    func logout(request: Request) throws -> ResponseRepresentable {
        try request.auth.logout()
        return Response(redirect: "/login")
    }
}
