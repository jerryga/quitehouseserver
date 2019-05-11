import Vapor
import FluentPostgreSQL

private let salt: String = "rsMBhwoxIOjH5SL"

public func routes(_ router: Router) throws {
    let dateformat: DateFormatter = DateFormatter()
    dateformat.dateFormat = "MMM dd,yyyy h:mm a"
    
    router.post(House.self, at: "add") { req, house -> Future<House> in
       
        let auth = try req.query.decode(AuthInfo.self)
        guard true == varifySignInfo(auth: auth) else {
            throw Abort(.badRequest, reason: "Invalid sign")
        }
        
        let houseCopy = house
        houseCopy.dateStr = dateformat.string(for: Date())

        return houseCopy.save(on: req)
    }

    router.get("house", String.parameter) { req -> Future<[House]> in
       
        let auth = try req.query.decode(AuthInfo.self)

        guard true == varifySignInfo(auth: auth) else {
            throw Abort(.badRequest, reason: "Invalid sign")
        }
        
        let cityName = try req.parameters.next(String.self).removingPercentEncoding
        return House.query(on: req).filter(\.cityName == cityName).all()
    }
    
    router.get("query", String.parameter) { req  -> Future<[House]> in
        
        let auth = try req.query.decode(AuthInfo.self)
        guard true == varifySignInfo(auth: auth) else {
            throw Abort(.badRequest, reason: "Invalid sign")
        }
        
        let aname = try req.parameters.next(String.self).removingPercentEncoding
        guard let queryname = aname else {
            throw Abort(.badRequest, reason: "Invalid sign")
        }
        
        return req.withPooledConnection(to: .psql, closure: { (db) -> Future<[House]> in
//            return db
//                .raw("SELECT * From House WHERE name LIKE '%\(aname)%' OR address LIKE '%\(aname)%'").sort(\.name, .descending).all(decoding: House.self)
            return db
                .raw("SELECT * From House WHERE name LIKE '%\(queryname)%' OR address LIKE '%\(queryname)%' ORDER BY dateStr DESC").all(decoding: House.self)
        })
    }
}

func varifySignInfo(auth: AuthInfo) -> Bool {
    
    let currentDate = Date()
    let currentTimeInterval = (Int)(currentDate.timeIntervalSince1970)
    let timestamp = (Int)(auth.timestamp)
    let deleta = abs((currentTimeInterval - timestamp!))
    print(deleta)
    
    if deleta > 300{
        return false
    }

    let combinedStr = (auth.timestamp + salt).MD5()
    print(combinedStr)
    if combinedStr == auth.sign {
        return true
    }
    
    return false
}

