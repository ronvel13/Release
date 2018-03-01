//
//  Photo.swift
//  VK-API
//
//  Created by Андрей Фоменко on 28.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class Photo: NSObject {
    
    var width       : Int? = nil
    var height      : Int? = nil
    var photo_604   : String? = nil
    var photo_75    : String? = nil
    var photo_130   : String? = nil
    var photo_807   : String? = nil
    var photo_1280  : String? = nil
    var photo_2560  : String? = nil
    
    init(arr : [String: Any]) {
        width       = arr["width"]      as? Int
        height      = arr["height"]     as? Int
        photo_604   = arr["photo_604"]  as? String
        photo_75    = arr["photo_75"]   as? String
        photo_130   = arr["photo_130"]  as? String
        photo_807   = arr["photo_807"]  as? String
        photo_1280  = arr["photo_1280"] as? String
        photo_2560  = arr["photo_2560"] as? String
    }
    
    override init() {
        super.init()
    }
}
