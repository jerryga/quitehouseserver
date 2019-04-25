//
//  House.swift
//  App
//
//  Created by Asa. Ga on 2019/4/16.
//

import Foundation
import Vapor
import FluentSQLite

/*
 
 31以下：适合睡眠
 31-45以下：安静
 45-65以下：中等安静
 65以上：吵闹、喧哗
 
 */

enum DecibelLevel: Int, Content{
    case None
    case Sleep
    case Quite
    case Moderate
    case Loud
}

struct Decibel: Content{
    var max: Float
    var time: Float
    var avrg: Float
    
    var level: DecibelLevel {
        get {
            if self.avrg <= 31 {
                return .Sleep
            }else if self.avrg <= 45 {
                return .Quite
            }else if self.avrg <= 65 {
                return .Moderate
            }else {
                return .Loud
            }
        }
    }
    
    init(max: Float, time: Float, avrg: Float) {
        self.max = max
        self.time = time
        self.avrg = avrg
    }
}

struct Location: Content{
    var latitude: Double
    var longitude: Double
}

struct AuthInfo: Content {
    var timestamp: Int
    var sign: String
}

final class House: SQLiteModel {
    
    var id: Int?
    
    var auth: AuthInfo?
    var location: Location?
    var decibel: Decibel?

    //用户输入小区名字
    var name: String?
    //留言&评论
    var comments: String?
    //地图获取
    var address: String?
    //eg. Beijing
    var cityName: String?
    //创建时间
    var dateStr: String?
    
    init(name: String) {
        self.name = name
    }
}

extension House: Migration { }
extension House: Content { }
extension House: Parameter { }

//Relation
/*
 struct Location: SQLiteModel{
 var id: Int?
 
 var latitude: Double
 var longitude: Double
 var houseID: Int
 
 }
 
 extension Location: Migration { }
 extension Location: Content { }
 extension Location: Parameter { }
 */

/*
extension House {
    var location: Children<House, Location> {
        return children(\.houseID)
    }
}

extension Location {
    var house: Parent<Location, House> {
        return parent(\.houseID)
    }
}
*/
