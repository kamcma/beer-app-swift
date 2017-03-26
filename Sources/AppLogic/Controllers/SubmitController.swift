import Vapor
import HTTP

final class SubmitController {
    let drop: Droplet

    init(drop: Droplet) {
        self.drop = drop
    }

    func addRoutes() {
        drop.group("submit") { submit in
            submit.get("brewery", handler: submitBreweryView)
            submit.get("beer", handler:submitBeerView)
            submit.post("brewery", handler: submitBrewery)
            submit.post("beer", handler: submitBeer)
        }
    }

    func submitBreweryView(request: Request) throws -> ResponseRepresentable {
        guard let user = try request.auth.user() as? User else {
            return Response(redirect: "/login")
        }
        return try drop.view.make("submit_brewery")
    }

    func submitBrewery(request: Request) throws -> ResponseRepresentable {
        guard let user = try request.auth.user() as? User else {
            return Response(redirect: "/login")
        }

        guard let name = request.formURLEncoded?["name"]?.string,
            let countryInt: Int = request.formURLEncoded?["country"]?.int else {
            return try drop.view.make("submit/brewery")
        }

        let country = Country(rawValue: countryInt)
        let slug = makeSlug(outOf: name)
        var brewery = Brewery(name: name, slug: slug, country: country, active: user.admin)
        try brewery.save()
        return Response(redirect: "/submit/brewery")

    }

    func submitBeerView(request: Request) throws -> ResponseRepresentable {
        guard let user = try request.auth.user() as? User else {
            return Response(redirect: "/login")
        }
        let breweries = try Brewery.query().filter("active", .equals, true).sort("name", .ascending).all()

        return try drop.view.make("submit_beer", [
            "breweries": breweries.makeNode()
        ])
    }

    func submitBeer(request: Request) throws -> ResponseRepresentable {
        guard let user = try request.auth.user() as? User else {
            return Response(redirect: "/login")
        }

        guard let name = request.formURLEncoded?["name"]?.string,
            let breweryId: Int = request.formURLEncoded?["brewery_id"]?.int,
            let brewery = try Brewery.query().filter("id", .equals, breweryId).first() else {
            return try drop.view.make("submit/beer")
        }

        let abv = request.formURLEncoded?["abv"]?.double,
            ibu = request.formURLEncoded?["ibu"]?.int
        var beer = Beer(name: name, slug: "temp", brewery: brewery, abv: abv, ibu: ibu, active: user.admin)
        try beer.save()

        return Response(redirect: "/submit/beer")
    }

    func makeSlug(outOf string: String) -> String {
        let nameWords = string.lowercased().components(separatedBy: [" ", "."])
        let exclude = ["brewery", "beer", "company", "co", "brewing"]
        let slugWords = nameWords.filter({ word in
            return !exclude.contains(word)
        })
        return slugWords.joined(separator: "-")
    }
}
