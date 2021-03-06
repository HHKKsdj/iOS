//
//  DetailDataModel.swift
//  test
//
//  Created by HK on 2021/2/26.
//

import UIKit

class DetailDataModel : NSObject, NSCoding {
    
    var province : String = ""
    var province_id : String = ""
    var city : String = ""
    var city_id : String = ""
    var risk_level : String = ""
    var high_in_desc : String = ""
    var low_in_desc : String = ""
    var out_desc : String = ""
    
    required init?(coder aDecoder: NSCoder) {
        self.province = aDecoder.decodeObject(forKey: "province") as! String
        self.province_id = aDecoder.decodeObject(forKey: "province_id") as! String
        self.city = aDecoder.decodeObject(forKey: "city") as! String
        self.city_id = aDecoder.decodeObject(forKey: "city_id") as! String
        self.risk_level = aDecoder.decodeObject(forKey: "risk_level") as! String
        self.high_in_desc = aDecoder.decodeObject(forKey: "high_in_desc") as! String
        self.low_in_desc = aDecoder.decodeObject(forKey: "low_in_desc") as! String
        self.out_desc = aDecoder.decodeObject(forKey: "out_desc") as! String
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(province, forKey: "province")
        aCoder.encode(province_id, forKey: "province_id")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(city_id, forKey: "city_id")
        aCoder.encode(risk_level, forKey: "risk_level")
        aCoder.encode(high_in_desc, forKey: "high_in_desc")
        aCoder.encode(low_in_desc, forKey: "low_in_desc")
        aCoder.encode(out_desc, forKey: "out_desc")
    }
    override init() {

    }
}
