//
//  Album.swift
//  VK-API
//
//  Created by Андрей Фоменко on 28.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class Album: NSObject {

    var id : Int? = nil
    var size : Int? = nil
    var thumbID : Int? = nil
    var title : String? = nil
    var descript : String? = nil
    var ownerID : Int? = nil
    
    init(arr : [String: Any]) {
        descript    = arr["description"] as? String
        id          = arr["id"] as? Int
        size        = arr["size"] as? Int
        thumbID     = arr["thumb_id"] as? Int
        title       = arr["title"] as? String
        ownerID     = arr["owner_id"] as? Int 
    }
    
    override init() {
        super.init()
    }
}
