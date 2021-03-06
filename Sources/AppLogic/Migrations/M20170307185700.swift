import Fluent
import VaporPostgreSQL

struct M20170307185700InitialMigration: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Brewery.entity) { breweries in
            breweries.id()
            breweries.string("name", length: 255)
            breweries.string("slug", length: 255, unique: true)
            breweries.int("country", optional: true)
            breweries.bool("active")
        }
        try database.create(Beer.entity) { beers in
            beers.id()
            beers.string("name", length: 255)
            beers.string("slug", length: 255)
            beers.parent(Brewery.self)
            beers.double("abv", optional: true)
            beers.int("ibu", optional: true)
            beers.bool("active")
        }
        try database.driver.raw("ALTER TABLE \"public\".\"beers\" "
            + "ADD FOREIGN KEY (\"brewery_id\") "
            + "REFERENCES \"public\".\"breweries\"(\"id\") "
            + "ON DELETE CASCADE ON UPDATE CASCADE;")
        try database.create(User.entity) {users in
            users.id()
            users.string("email", length: 255, unique: true)
            users.string("password")
            users.string("first_name", length: 255)
            users.string("last_name", length: 255)
            users.bool("admin")
        }
        try database.create(BeerRating.entity) { beerRatings in
            beerRatings.id()
            beerRatings.parent(User.self)
            beerRatings.parent(Beer.self)
            beerRatings.bool("thumb_up")
        }
        try database.driver.raw("ALTER TABLE \"public\".\"beerratings\" "
            + "ADD FOREIGN KEY (\"user_id\") "
            + "REFERENCES \"public\".\"users\"(\"id\") "
            + "ON DELETE CASCADE ON UPDATE CASCADE;")
        try database.driver.raw("ALTER TABLE \"public\".\"beerratings\" "
            + "ADD FOREIGN KEY (\"beer_id\") "
            + "REFERENCES \"public\".\"beers\"(\"id\") "
            + "ON DELETE CASCADE ON UPDATE CASCADE;")
    }

    static func revert(_ database: Database) throws {
        try database.delete(BeerRating.entity)
        try database.delete(Beer.entity)
        try database.delete(Brewery.entity)
        try database.delete(User.entity)
    }
}
