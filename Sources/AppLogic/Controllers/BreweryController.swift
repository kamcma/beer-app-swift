import Vapor
import HTTP

final class BreweryController {
    let drop: Droplet

    init(drop: Droplet) {
        self.drop = drop
    }

    func addRoutes() {
        drop.get(String.self, handler: breweryView)
    }

    func breweryView(request: Request, slug: String) throws -> ResponseRepresentable {
        guard let brewery = try Brewery.query().filter("slug", slug).first() else {
            throw Abort.notFound
        }
        return try drop.view.make("brewery", [
            "brewery": brewery.name
        ])
    }
}
