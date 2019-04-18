//
//  House.swift
//  App
//
//  Created by baidu on 2019/4/16.
//

import Foundation
import Vapor
import FluentSQLite

struct Decibel: Content{
    
    var max: Int
    var time: Int
    var avrg: Int
    
    init(max: Int, time: Int, avrg: Int) {
        self.max = max
        self.time = max
        self.avrg = max
    }
}

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
