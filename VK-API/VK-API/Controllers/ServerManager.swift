//
//  ServerManager.swift
//  APITest_VK
//
//  Created by Андрей Фоменко on 11.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit
import Alamofire

class ServerManager: NSObject {
    
    var accessToken = AccessToken()
    let keyToken            = "keyToken"
    let keyExpirationDate   = "keyExpirationDate"
    let keyUserId           = "keyUserId"
    //self.requestQueue = dispatch_queue_create("iOSDevCourse.requestVk", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    let queue = DispatchQueue(label: "queuename", attributes: .concurrent)
    
    static func sharedManager() -> ServerManager {
        let manager = ServerManager()
        return manager
    }
    
    override init() {
        super.init()
        loadSettings()
    }
    
    func loadSettings() {
    
        let userDefaults = UserDefaults.standard
        self.accessToken.token = userDefaults.object(forKey: keyToken) as? String
        self.accessToken.expirationDate = userDefaults.object(forKey: keyExpirationDate) as? Date
        self.accessToken.userId = userDefaults.object(forKey: keyUserId) as? String
    }
    
    func saveSettings(token : AccessToken ) {
    
        let userDefaults = UserDefaults.standard
        userDefaults.set(token.token, forKey: keyToken)
        userDefaults.set(token.expirationDate, forKey: keyExpirationDate)
        userDefaults.set(token.userId, forKey: keyUserId)
        userDefaults.synchronize()
    }
    
    func authorizeUser(user: User,
                       completion: @escaping (_ token : AccessToken?) -> Void) {
        
        if self.accessToken.expirationDate?.compare(Date.init()) == .orderedDescending {
            
            self.getUserInformation(userId: accessToken.userId!, onSuccess: { user, counters  in
                    completion(self.accessToken)
            }, onFailure: { (error, statusCode) in
                    completion(nil)
            })
        } else {
        
        
            let a = LoginViewController()
            let viewController = a.initWithCompletionBlock { (token) in

                self.saveSettings(token: token!)
                self.accessToken = token!
                
                if token != nil {
                    self.getUserInformation(userId: self.accessToken.userId!, onSuccess: { user, counters in
                            completion(self.accessToken)
                    }, onFailure: { (error, statusCode) in
                            completion(nil)
                    })
                } else {
                    completion(nil)
                }
            }
          
            let navigation = UINavigationController.init(rootViewController: viewController)
            let mainViewController = UIApplication.shared.windows.first?.rootViewController
            mainViewController?.present(navigation, animated: true, completion: nil)
        }
    }
    
    public func getFriendsWithOffset(offset: NSInteger,
                                      count: NSInteger,
                                      userId: String,
                                  onSuccess: @escaping (_ friends : Array<Person>) -> Void,
                                  onFailure: @escaping (_ error: Error, _ statusCode: NSInteger) -> Void) {
            //60054215 // 222754621
        let dictionary = ["user_id":    userId,
                          "order":      "hints",
                          "count":      count,
                          "offset":     offset,
                          "fields":     "photo_50,online",
                          "name_case":  "nom",
                          "v":          "5.73",
                          "access_token": accessToken.token!] as [String : Any]
       
        request("https://api.vk.com/method/friends.get", method: .get, parameters: dictionary).responseJSON {
            (response) in
            switch response.result {
            case .success(_) :
                var persons = Array<Person>()
                let array = ((response.result.value as? [String: Any])?["response"] as? [String: Any])?["items"] as? [[String: Any]]
                for arr in array! {
                    let person = Person(arr: arr)
                    persons.append(person)
                }
                onSuccess(persons)
            case .failure(let error): onFailure(error, (response.response?.statusCode)!)
            }
        }
    }
    
    public func getOnlineFriendsWithOffset(offset: NSInteger,
                                     count: NSInteger,
                                     userId: String,
                                     onSuccess: @escaping (_ friends : Array<Person>) -> Void,
                                     onFailure: @escaping (_ error: Error, _ statusCode: NSInteger) -> Void) {
        //60054215 // 222754621
        let dictionary = ["user_id":    userId,
                          "order":      "hints",
                          "count":      count,
                          "offset":     offset,
                          "fields":     "photo_50,online",
                          "name_case":  "nom",
                          "v":          "5.73",
                          "access_token": accessToken.token!] as [String : Any]
        
        request("https://api.vk.com/method/friends.get", method: .get, parameters: dictionary).responseJSON {
            (response) in
            switch response.result {
            case .success(_) :
                var persons = Array<Person>()
                let array = ((response.result.value as? [String: Any])?["response"] as? [String: Any])?["items"] as? [[String: Any]]
                for arr in array! {
                    let person = Person(arr: arr)
                    if person.online == 1 {
                        persons.append(person)
                    }
                }
                onSuccess(persons)
            case .failure(let error): onFailure(error, (response.response?.statusCode)!)
            }
        }
    }
    
    public func getUserInformation(userId: String,
                                   onSuccess: @escaping (_ user : User, _ counters : UserCounters) -> Void,
                                onFailure: @escaping (_ error: Error, _ statusCode: NSInteger) -> Void) {
        
        //let group = DispatchGroup()
        //group.enter()
        var user = User()
        var counters = UserCounters()
        let dictionary = ["user_ids":    userId,
                          "fields":     "photo_200,city,sex,bdate,city,country,online,education,counters",
                          "name_case":  "nom",
                          "v":          "5.73",
                          "access_token": accessToken.token!] as [String : Any]
        
        request("https://api.vk.com/method/users.get", method: .get, parameters: dictionary).responseJSON {
            (response) in
            switch response.result {
            case .success(_) :
                let array = (response.result.value as? [String: Any])?["response"] as? [[String: Any]]
                for  arr in array! {
                    
                    user = User(arr: arr)
                    
                    if let city = arr["city"] as? [String: Any] {
                        user.cityName = city["title"]! as? String
                    }
                    
                    if let country = arr["country"] as? [String: Any] {
                        user.countryName = country["title"]! as? String
                    }
                    
                    if let count = arr["counters"] as? [String: Any] {
                        counters = UserCounters(arr: count)
                        user.countFriends = count["friends"] as? Int
                    }
                    
                   /* self.getCityUser(
                        cityId: String((arr["city"] as? Int) ?? -1),
                        onSuccess: { (cityName) in
                            user.cityName = cityName
                            self.getCountryUser(
                                coutryId: String((arr["country"] as? Int) ?? -1),
                                onSuccess: { (countryName) in
                                    user.countryName = countryName
                                    group.leave()
                            }) { (error: Error, statusCode: NSInteger) in
                                print("error = \(error.localizedDescription), code = \(statusCode)")
                            }
                    }) { (error: Error, statusCode: NSInteger) in
                        print("error = \(error.localizedDescription), code = \(statusCode)")
                    }*/
                }
                onSuccess(user, counters)
            case .failure(let error) :
                onFailure(error, (response.response?.statusCode)!)
            }
        }
        
       /* group.notify(queue: DispatchQueue.main) {
            onSuccess(user)
        }*/
    }
    
    public func getWallPostsWithOffset(offset: NSInteger,
                                       count: NSInteger,
                                       userId: String,
                                       onSuccess: @escaping (_ posts : Array<Person>) -> Void,
                                       onFailure: @escaping (_ error: Error, _ statusCode: NSInteger) -> Void) {
        
        let dictionary = ["owner_id":   userId,
                          "count":      count,
                          "offset":     offset,
                          "filter":     "all",
                          "extended":   "1",
                          "v":           "5.73",
                          "access_token": accessToken.token!] as [String : Any]
        
        request("https://api.vk.com/method/wall.get", method: .get, parameters: dictionary).responseJSON {
            (response) in
            switch response.result {
            case .success(_) :
                let persons = Array<Person>()
                let array = (response.result.value as? [String: Any])?["response"] as? [[String: Any]]
                for arr in array! {
                    
                }
                onSuccess(persons)
            case .failure(let error): onFailure(error, (response.response?.statusCode)!)
            }
        }
    }
    
    func getAlbumsById(userId: String,
                       onSuccess: @escaping (_ albums : Array<Album>) -> Void,
                       onFailure: @escaping (_ error: Error, _ statusCode: NSInteger) -> Void) {
    
        let dictionary = ["owner_id":       userId,
                          "need_system":    1,
                          "v":              "5.73",
                          "access_token": accessToken.token!] as [String : Any]
        
        request("https://api.vk.com/method/photos.getAlbums", method: .get, parameters: dictionary).responseJSON {
            (response) in
            switch response.result {
            case .success(_) :
                var album = Array<Album>()
                let array = ((response.result.value as? [String: Any])?["response"] as? [String: Any])?["items"] as? [[String: Any]]
                if array != nil {
                    for arr in array! {
                        let alb = Album(arr: arr)
                        album.append(alb)
                    }
                }
                onSuccess(album)
            case .failure(let error): onFailure(error, (response.response?.statusCode)!)
            }
        }
   
    }
    
    public func getPhotosFromAlbum(offset: NSInteger,
                                   count: NSInteger,
                                   userId: Int,
                                   albumId: Int,
                                   onSuccess: @escaping (_ photos : Array<Photo>?) -> Void,
                                   onFailure: @escaping (_ error: Error, _ statusCode: NSInteger) -> Void) {
        
        let dictionary = ["owner_id":   userId,
                          "album_id":   albumId,
                          "count":      count,
                          "offset":     offset,
                          "rev":        "1",
                          "extended":   "0",
                          "v":           "5.73",
                          "access_token": accessToken.token!] as [String : Any]

            request("https://api.vk.com/method/photos.get", method: .get, parameters: dictionary).responseJSON {
                (response) in
                switch response.result {
                case .success(_) :
                        var photos = Array<Photo>()
                        let array = ((response.result.value as? [String: Any])?["response"] as? [String: Any])?["items"] as? [[String: Any]]
                        if array != nil {
                            for arr in array! {
                                let ph = Photo(arr: arr)
                                photos.append(ph)
                            }
                        }
                        onSuccess(photos)
                case .failure(let error): onFailure(error, (response.response?.statusCode)!)
                }
            }
    }
    
    public func getVideoUsers(offset: NSInteger,
                              count: NSInteger,
                              userId: Int,
                              onSuccess: @escaping (_ videos : Array<Video>, _ videosInGroup: Array<VideoInGroup>) -> Void,
                              onFailure: @escaping (_ error: Error, _ statusCode: NSInteger) -> Void) {
        
        let dictionary = ["owner_id":   userId,
                          "count":      count,
                          "offset":     offset,
                          "extended":   "1",
                          "v":           "5.73",
                          "access_token": accessToken.token!] as [String : Any]
        
        request("https://api.vk.com/method/video.get", method: .get, parameters: dictionary).responseJSON {
            (response) in
            switch response.result {
            case .success(_) :
                var videos = Array<Video>()
                var array = ((response.result.value as? [String: Any])?["response"] as? [String: Any])?["items"] as? [[String: Any]]
                if array != nil {
                    for arr in array! {
                        let video = Video(arr: arr)
                        videos.append(video)
                    }
                }
                
                var videosInGroup = Array<VideoInGroup>()
                array = ((response.result.value as? [String: Any])?["response"] as? [String: Any])?["groups"] as? [[String: Any]]
                if array != nil {
                    for arr in array! {
                        let videoInGroup = VideoInGroup(arr: arr)
                        videosInGroup.append(videoInGroup)
                    }
                }
                onSuccess(videos, videosInGroup)
            case .failure(let error): onFailure(error, (response.response?.statusCode)!)
            }
        }
    }
    
}
