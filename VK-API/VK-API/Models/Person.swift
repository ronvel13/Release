//
//  Person.swift
//  APITest_VK
//
//  Created by Андрей Фоменко on 12.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var firstName   : String
    var lastName    : String
    var photo_50    : String?
    var user_id     : String
    
    init(arr : [String: Any]) {
        
        firstName   = arr["first_name"] as! String
        lastName    = arr["last_name"]  as! String
        photo_50    = arr["photo_50"]   as? String
        user_id     = String(arr["user_id"]    as! Int)
    }
}
