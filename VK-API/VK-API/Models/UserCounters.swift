//
//  UserCounters.swift
//  VK-API
//
//  Created by Андрей Фоменко on 21.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class UserCounters: NSObject {
    
    var videos          : Int?  = nil
    var audios          : Int?  = nil
    var photos          : Int?  = nil
    var friends         : Int?  = nil
    var groups          : Int?  = nil
    var onlineFriends   : Int?  = nil
    var mutualFriends   : Int?  = nil
    var followers       : Int?  = nil
    
    init(arr : [String: Any]) {
        
        videos          = arr["videos"] as? Int
        audios          = arr["audios"] as? Int
        photos          = arr["photos"] as? Int
        friends         = arr["friends"] as? Int
        groups          = arr["groups"] as? Int
        onlineFriends   = arr["online_friends"] as? Int
        mutualFriends   = arr["mutual_friends"] as? Int
        followers       = arr["followers"] as? Int
    }
    
    override init() {
        super.init()
    }
}
