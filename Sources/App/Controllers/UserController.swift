import Vapor
import HTTP
import VaporPostgreSQL
import Turnstile

final class UserController {

    func addRoutes(drop: Droplet) {
        drop.get("register", handler: registerView)
        drop.post("register", handler: register)
        drop.get("login", handler: loginView)
        //drop.post("login", handler: nil)
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
            return Response(redirect: "/")
        } catch {
            return try drop.view.make("register")
        }
    }

}
