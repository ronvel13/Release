//
//  AccessToken.swift
//  VK-API
//
//  Created by Андрей Фоменко on 20.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class AccessToken: NSObject {
   
    var expirationDate: Date?
    var token:          String?
    var userId:         String?
}
