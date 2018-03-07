//
//  VideoInGroup.swift
//  VK-API
//
//  Created by Андрей Фоменко on 07.03.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class VideoInGroup: NSObject {
    var id         : Int?    = nil
    var name       : String? = nil
    var photo_100  : String? = nil
    var photo_200  : String? = nil
    var photo_50   : String? = nil
    var screenName : String? = nil
    
    init(arr : [String: Any]) {
        
        id          = arr["id"]           as? Int
        name        = arr["name"]         as? String
        photo_100   = arr["photo_100"]    as? String
        photo_200   = arr["photo_200"]    as? String
        photo_50    = arr["photo_50"]     as? String
        screenName  = arr["screen_name"]  as? String
    }
    
    override init() {
        super.init()
    }
}
