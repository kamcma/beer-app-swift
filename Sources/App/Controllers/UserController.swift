import Vapor
import HTTP
import VaporPostgreSQL

final class UserController {

    func addRoutes(drop: Droplet) {
        drop.get("register", handler: registerView)
        //drop.post("register", handler: nil)
        drop.get("login", handler: loginView)
        //drop.post("login", handler: nil)
    }

    func registerView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("register")
    }

    func loginView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("login")
    }

    /*func register(request: Request) throws -> ResponseRepresentable {
        throw 
    }*/

}
