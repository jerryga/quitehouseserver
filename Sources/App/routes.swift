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
    
    router.get("query", String.parameter) { req  -> Future<[House]> in
        let aname = try req.parameters.next(String.self)
        return req.withPooledConnection(to: DatabaseIdentifier<SQLiteDatabase>.sqlite, closure: { (db) -> Future<[House]> in
            return db
                .raw("SELECT * From House WHERE name LIKE '%\(aname)%' address LIKE '%\(aname)%'").all(decoding: House.self)
        })
    }
}

