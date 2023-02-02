//
//  BugsModel.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//

import Foundation
import ObjectMapper


class AllData: NSObject, NSCoding {

    var id: Int
    var name: String
    var shadow: String
    var price: Int
    var northern: String
    var southern: String
    var time: String
    var isAllDay: Bool
    var isAllYear: Bool
    var location: String
    
    init(model: BugsModel) {
        self.id = model.id
        self.name = model.name?.name ?? ""
        self.shadow = model.shadow
        self.price = model.price
        self.northern = model.availability?.monthNorthern ?? ""
        self.southern = model.availability?.monthSouthern ?? ""
        self.time = model.availability?.time ?? ""
        self.isAllDay = model.availability?.isAllDay ?? false
        self.isAllYear = model.availability?.isAllYear ?? false
        self.location = model.availability?.location ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name-TWzh")
        aCoder.encode(shadow, forKey: "shadow")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(northern, forKey: "month-northern")
        aCoder.encode(southern, forKey: "month-southern")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(isAllDay, forKey: "isAllDay")
        aCoder.encode(isAllYear, forKey: "isAllYear")
        aCoder.encode(location, forKey: "location")
    }

    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.name = aDecoder.decodeObject(forKey: "name-TWzh") as? String ?? ""
        self.shadow = aDecoder.decodeObject(forKey: "shadow") as? String ?? ""
        self.price = aDecoder.decodeInteger(forKey: "price")
        self.northern = aDecoder.decodeObject(forKey: "month-northern") as? String ?? ""
        self.southern = aDecoder.decodeObject(forKey: "month-southern") as? String ?? ""
        self.time = aDecoder.decodeObject(forKey: "time") as? String ?? ""
        self.isAllDay = aDecoder.decodeBool(forKey: "isAllDay")
        self.isAllYear = aDecoder.decodeBool(forKey: "isAllYear")
        self.location = aDecoder.decodeObject(forKey: "location") as? String ?? ""
    }
}

class BugsModel: Mappable {

    var id: Int = 0
    var name: Name?
    var availability: Availability?
    var price: Int = 0
    var shadow: String = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        availability <- map["availability"]
        price <- map["price"]
        shadow <- map["shadow"]
    }
}

class Name: Mappable {

    var name: String = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        name <- map["name-TWzh"]
    }
}

class Availability: Mappable {

    var monthNorthern: String = ""
    var monthSouthern: String = ""
    var time: String = ""
    var isAllDay: Bool = false
    var isAllYear: Bool = false
    var location: String = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        monthNorthern <- map["month-northern"]
        monthSouthern <- map["month-southern"]
        time <- map["time"]
        isAllDay <- map["isAllDay"]
        isAllYear <- map["isAllYear"]
        location <- map["location"]
    }
}
