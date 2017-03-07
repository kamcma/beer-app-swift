import Fluent
import VaporPostgreSQL

struct MigrationZero: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Brewery.entity) { breweries in
            breweries.id()
            breweries.string("name", optional: false)
            breweries.string("slug", optional: false)
        }
        try database.create(Beer.entity) { beers in
            beers.id()
            beers.string("name", optional: false)
            beers.string("slug", optional: false)
            beers.parent(Brewery.self, optional: false)
            beers.double("abv")
        }
        try database.create(User.entity) {users in
            users.id()
            users.string("email")
            users.string("password")
            users.string("first_name")
            users.string("last_name")
        }
        try database.create(BeerRating.entity) { beerRatings in
            beerRatings.id()
            beerRatings.int("stars", optional: false)
            beerRatings.parent(User.self, optional: false)
            beerRatings.parent(Beer.self, optional: false)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(BeerRating.entity)
        try database.delete(User.entity)
        try database.delete(Beer.entity)
        try database.delete(Brewery.entity)
    }
}
