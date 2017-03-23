import Vapor
import HTTP

final class BeerController {
    let drop: Droplet

    init(drop: Droplet) {
        self.drop = drop
    }

    func addRoutes() {
        drop.get(String.self, handler: breweryView)
        drop.get(String.self, String.self, handler: beerView)
        drop.get("results", handler: resultsView)
    }

    func breweryView(request: Request, brewerySlug: String) throws -> ResponseRepresentable {
        guard let brewery = try Brewery.query().filter("slug", brewerySlug).first() else {
            throw Abort.notFound
        }
        return try drop.view.make("brewery", [
            "brewery": brewery.name
        ])
    }

    func beerView(request: Request, brewerySlug: String, beerSlug: String) throws -> ResponseRepresentable {
        guard let brewery = try Brewery.query().filter("slug", brewerySlug).first(),
            let beer = try brewery.beers().filter("slug", beerSlug).first() else {
                throw Abort.notFound
            }

        return try drop.view.make("beer", [
            "brewery": brewery.name,
            "brewerySlug": brewery.slug,
            "beer": beer.name
        ])
    }

    func resultsView(request: Request) throws -> ResponseRepresentable {
        guard let query = request.query?["query"]?.string else {
            return try drop.view.make("results")
        }

        return try drop.view.make("results", [
            "query": query
        ])
    }
}
