//
//  CityDataModel.swift
//  test
//
//  Created by HK on 2021/2/25.
//

import UIKit

class CityDataModel : NSObject, NSCoding {
    
    var city : String = ""
    var city_id : String = ""
    
    required init?(coder aDecoder: NSCoder) {
        self.city = aDecoder.decodeObject(forKey: "city") as! String
        self.city_id = aDecoder.decodeObject(forKey: "city_id") as! String
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: "city")
        aCoder.encode(city_id, forKey: "city_id")
    }
    
    override init() {

    }
    
}
