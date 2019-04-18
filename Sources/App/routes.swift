import Vapor
import FluentSQLite
import CoreLocation

public func routes(_ router: Router) throws {
 
    router.post(House.self, at: "add") { req, house -> Future<House> in
        return house.save(on: req);
    }

    router.get("house", String.parameter) { req -> Future<[House]> in
        let cityName = try req.parameters.next(String.self)
        return House.query(on: req).filter(\.cityName == cityName).all()
    }
}

