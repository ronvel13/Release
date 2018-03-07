//
//  Video.swift
//  VK-API
//
//  Created by Андрей Фоменко on 06.03.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var countComments   : Int?    = nil
    var date            : String? = nil
    var descript        : String? = nil
    var duration        : String? = nil
    var videoID         : Int?    = nil
    var likeCount       : Int?    = nil
    var ownerID         : Int?    = nil
    var photo_130       : String? = nil
    var photo_320       : String? = nil
    var photo_640       : String? = nil
    var platform        : String? = nil
    var playerURl       : String? = nil
    var reposts         : Int?    = nil
    var title           : String? = nil
    var views           : Int?    = nil
    var nameGroup       : String? = nil
    
    init(arr : [String: Any]) {
        
        countComments   = arr["comments"]  as? Int
        descript        = arr["description"]  as? String
        videoID         = arr["id"]  as? Int
        likeCount       = (arr["likes"]  as? [String: Any])?["count"] as? Int
        ownerID         = arr["owner_id"]  as? Int
        photo_130       = arr["photo_130"]  as? String
        photo_320       = arr["photo_320"]  as? String
        photo_640       = arr["photo_640"]  as? String
        platform        = arr["platform"]  as? String
        playerURl       = arr["player"]  as? String
        reposts         = (arr["reposts"]  as? [String: Any])?["count"] as? Int
        title           = arr["title"]  as? String
        views           = arr["views"]  as? Int
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm:ss"
        dateFormater.timeZone =  TimeZone.init(secondsFromGMT: 3)
        let durationTime = Date.init(timeIntervalSince1970: (arr["duration"]  as? Double)!)
        duration = dateFormater.string(from: durationTime)
        
        dateFormater.dateFormat = "dd MMM yyyy "
        let dateTime = Date.init(timeIntervalSince1970: (arr["date"]  as? Double)!)
        date = dateFormater.string(from: dateTime)
    }
    
    override init() {
        super.init()
    }
}
