//
//  User.swift
//  APITest_VK
//
//  Created by Андрей Фоменко on 16.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var firstName       : String?   = nil
    var lastName        : String?   = nil
    var onlineStatus    : Bool?     = nil
    var photoURL        : String?   = nil
    var userId          : String?   = nil
    var universityName  : String?   = nil
    var cityName        : String?   = nil
    var countryName     : String?   = nil
    
    init(arr : [String: Any]) {
        
        self.firstName      = arr["first_name"] as? String
        self.lastName       = arr["last_name"]  as? String
        self.userId         = String(arr["uid"]  as! Int)
        self.photoURL       = arr["photo_200"]  as? String
        self.universityName = arr["university_name"]  as? String
        self.onlineStatus   = arr["online"]  as? Bool
    }
    
    override init() {
        super.init()
    }
}
