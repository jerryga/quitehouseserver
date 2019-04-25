import Vapor
import FluentSQLite

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
            
            let combinedStr = (String(auth.timestamp) + salt).MD5()
            throw Abort(.badRequest, reason: "Invalid sign :\(combinedStr)")
        }
        
        let cityName = try req.parameters.next(String.self)
        return House.query(on: req).filter(\.cityName == cityName).all()
    }
    
    router.get("query", String.parameter) { req  -> Future<[House]> in
        
        let auth = try req.query.decode(AuthInfo.self)
        guard true == varifySignInfo(auth: auth) else {
            throw Abort(.badRequest, reason: "Invalid sign")
        }
        
        let aname = try req.parameters.next(String.self)
        return req.withPooledConnection(to: DatabaseIdentifier<SQLiteDatabase>.sqlite, closure: { (db) -> Future<[House]> in
//            return db
//                .raw("SELECT * From House WHERE name LIKE '%\(aname)%' OR address LIKE '%\(aname)%'").sort(\.name, .descending).all(decoding: House.self)
            return db
                .raw("SELECT * From House WHERE name LIKE '%\(aname)%' OR address LIKE '%\(aname)%' ORDER BY dateStr DESC").all(decoding: House.self)
        })
    }
}

func varifySignInfo(auth: AuthInfo) -> Bool {
    
    let currentDate = Date()
    let currentTimeInterval = currentDate.timeIntervalSince1970
    let deleta = abs((currentTimeInterval - auth.timestamp))
    print(deleta)
    
//    if deleta > 300{
//        return false
//    }

    let combinedStr = (String(auth.timestamp) + salt).MD5()
    if combinedStr == auth.sign {
        return true
    }
    
    return false
}

