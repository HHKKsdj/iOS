//
//  Network.swift
//  test
//
//  Created by HK on 2021/2/25.
//

import UIKit
import Alamofire
import SwiftyJSON

let City_URL = "https://apis.juhe.cn/springTravel/citys?key=26864d1b68e857e5d3b68a45ab690948"
let Detail_URL = "https://apis.juhe.cn/springTravel/query?key=26864d1b68e857e5d3b68a45ab690948"


class Network {
    static let shared = Network()
    
    func CityList(_ completion: @escaping (Error?, [CityDataModel]?) -> ()) {
        let url = "\(City_URL)"
        AF.request(url).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    let json = JSON(value)
                    var list = [CityDataModel]()
//                    print(json)
                    let provinceList = json["result"]
                    for (_,subJson):(String,JSON) in provinceList {
                        let cityList = subJson["citys"]
                        for (_,subJson2):(String,JSON) in cityList {
                            let item = CityDataModel()
                            item.city = subJson2["city"].string!
                            item.city_id = subJson2["city_id"].string!
                            list.append(item)
                        }
                    }
                    completion(nil, list)
                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
    func DetailList(from:Int, to:Int, _ completion: @escaping (Error?, [DetailDataModel]?) -> ()) {
        let url = "\(Detail_URL)&from=\(from)&to=\(to)"

        AF.request(url).responseJSON { responds in

            switch responds.result {
                case .success(let value):
                    var list = [DetailDataModel]()
                    let json = JSON(value)
//                        print(json)
                    let result = json["result"]

                    let from_info = result["from_info"]

                    let from_city = DetailDataModel()
                    let to_city = DetailDataModel()

                    from_city.province = from_info["province_name"].string!
                    from_city.province_id = from_info["province_id"].string!
                    from_city.city = from_info["city_name"].string!
                    from_city.city_id = from_info["city_id"].string!
                    from_city.risk_level = from_info["risk_level"].string!
                    from_city.high_in_desc = from_info["high_in_desc"].string!
                    from_city.low_in_desc = from_info["low_in_desc"].string!
                    from_city.out_desc = from_info["out_desc"].string!

                    let to_info = result["to_info"]

                    to_city.province = to_info["province_name"].string!
                    to_city.province_id = to_info["province_id"].string!
                    to_city.city = to_info["city_name"].string!
                    to_city.city_id = to_info["city_id"].string!
                    to_city.risk_level = to_info["risk_level"].string!
                    to_city.high_in_desc = to_info["high_in_desc"].string!
                    to_city.low_in_desc = to_info["low_in_desc"].string!
                    to_city.out_desc = to_info["out_desc"].string!

                    list.append(from_city)
                    list.append(to_city)

                    completion(nil, list)

                case .failure(let error):
                    completion(error, nil)
            }
        }
    }
    
    func AllDataList(_ completion: @escaping (Error?, [DetailDataModel]?) -> ()) {
        var list = [DetailDataModel]()
        var bottom = 10001
        let data = UserDefaults.standard.data(forKey: "detailList")
        if data != nil {
            list = try!  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! [DetailDataModel]
            let i = list.count
            bottom = Int(list[i-1].city_id)!
        }
        
        for i in (bottom...10360) {
            if i%2==0 {
                continue
            }
            print("\(i),\(i+1)")
            
            let url = "\(Detail_URL)&from=\(i)&to=\(i+1)"

            AF.request(url).responseJSON { responds in

                switch responds.result {
                    case .success(let value):
                        let json = JSON(value)
//                        print(json)
                        let result = json["result"]

                        let from_info = result["from_info"]

                        let from_city = DetailDataModel()
                        let to_city = DetailDataModel()

                        from_city.province = from_info["province_name"].string!
                        from_city.province_id = from_info["province_id"].string!
                        from_city.city = from_info["city_name"].string!
                        from_city.city_id = from_info["city_id"].string!
                        from_city.risk_level = from_info["risk_level"].string!
                        from_city.high_in_desc = from_info["high_in_desc"].string!
                        from_city.low_in_desc = from_info["low_in_desc"].string!
                        from_city.out_desc = from_info["out_desc"].string!

                        let to_info = result["to_info"]

                        to_city.province = to_info["province_name"].string!
                        to_city.province_id = to_info["province_id"].string!
                        to_city.city = to_info["city_name"].string!
                        to_city.city_id = to_info["city_id"].string!
                        to_city.risk_level = to_info["risk_level"].string!
                        to_city.high_in_desc = to_info["high_in_desc"].string!
                        to_city.low_in_desc = to_info["low_in_desc"].string!
                        to_city.out_desc = to_info["out_desc"].string!

                        list.append(from_city)
                        list.append(to_city)
                        if i+1 == 10360{
                            completion(nil, list)
                            print("pass detaillist")
                        }
                    case .failure(let error):
                        completion(error, nil)
                }
            }
        }
    }
}
