import Vapor
import FluentSQLite

public func routes(_ router: Router) throws {
    let dateformat: DateFormatter = DateFormatter()
    dateformat.dateFormat = "MMM dd,yyyy h:mm a"
    
    router.post(House.self, at: "add") { req, house -> Future<House> in
        let houseCopy = house
        houseCopy.dateStr = dateformat.string(for: Date())
        return houseCopy.save(on: req)
    }

    router.get("house", String.parameter) { req -> Future<[House]> in
        let cityName = try req.parameters.next(String.self)
        return House.query(on: req).filter(\.cityName == cityName).all()
    }
}

