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

enum DecibelLevel: Int, Codable{
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
    var level: DecibelLevel = .None

    init(max: Float, time: Float, avrg: Float) {
        self.max = max
        self.time = time
        self.avrg = avrg
        
        if self.avrg <= 31 {
            self.level = .Sleep
        }else if self.avrg <= 45 {
            self.level = .Quite
        }else if self.avrg <= 65 {
            self.level = .Moderate
        }else {
            self.level = .Loud
        }
    }
}

struct Location: Codable{
    var latitude: Double
    var longitude: Double
}

final class House: SQLiteModel {
    
    var id: Int?
    
    var decibel: Decibel?
    var location: Location?
    
    var name: String
    var comments: String?
    
    var cityName: String?
    
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
