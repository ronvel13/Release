//
//  PersonWallTableViewController.swift
//  APITest_VK
//
//  Created by Андрей Фоменко on 15.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit
import Alamofire

protocol CountersDelegate {
    func collectionCellPressedAtIndex(indexPath : IndexPath, keys : Array<String>)
}

class PersonWallTableViewController: UITableViewController, CountersDelegate {

    var userID = ""
    let postsCount = 2
    var userInformation = User()
    var userCounters = UserCounters()
    var wallInformation = Array<Wall>()
    @IBOutlet var tableViewWall: UITableView!
    let manager = ServerManager.sharedManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // let queue = DispatchQueue(label: "com.myapp.queue")
       // queue.async {
        //    DispatchQueue.main.async {
                self.getUserInformation()
         //   }
        //}
    }

    func getUserInformation() {
        
        manager.getUserInformation(userId: userID,
                                   onSuccess: { userInformation, userCounters  in
                                    self.userInformation = userInformation
                                    self.userCounters = userCounters
                                    
                                    //self.getWallPostsInformation()
                                    self.tableView.reloadData()
        }) { (error: Error, statusCode: NSInteger) in
            print("error = \(error.localizedDescription), code = \(statusCode)")
        }
    }
    
    func getWallPostsInformation() {
        
        manager.getWallPostsWithOffset(offset: wallInformation.count,
                                       count: postsCount,
                                       userId: userID,
                                       onSuccess: { (wallInformation) in
                                    
        }) { (error: Error, statusCode: NSInteger) in
            print("error = \(error.localizedDescription), code = \(statusCode)")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = "infoCell"
        let counterCellIdentifier = "counterCell"
        
        if  indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserFriendTableViewCell
            
            if cell == nil {
                cell = UserFriendTableViewCell.init(style: .default, reuseIdentifier: identifier)
            }
            
            if let firstName = userInformation.firstName {
                if let lastName = userInformation.lastName {
                    cell?.name.text = firstName + " " + lastName
                }
            }
            
            if let onlineStatus = userInformation.onlineStatus {
                cell?.isOnline.text = onlineStatus ? "Online" : "Offline"
            }
            
            var information : String = ""
            cell?.informationAboutUser.text = information
            if let country = userInformation.countryName {
                information += country
                if let city = userInformation.cityName {
                    information += information == "" ? " " : ", "
                    information += city
                    cell?.informationAboutUser.text = information
                }
            } else if let city = userInformation.cityName {
                information += city
                cell?.informationAboutUser.text = information
            }
            
            if let photo = userInformation.photoURL {
                request(photo).response(completionHandler: { (response) in
                    guard
                        let data = response.data,
                        let image = UIImage(data: data)
                        else { return }
                    
                    cell?.photoUser.image = image
                    
                    let imageLayer = cell?.photoUser.layer;
                    imageLayer?.cornerRadius = 50
                    imageLayer?.masksToBounds = true
                    
                    cell?.layoutSubviews()
                })
            }
            return cell!
        } else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CountersTableViewCell
            
            if cell == nil {
              cell = CountersTableViewCell.init(style: .default, reuseIdentifier: counterCellIdentifier)
            }
            //let cell = CountersTableViewCell.init(style: .default, reuseIdentifier: counterCellIdentifier)
            
            if self.userCounters.friends != nil {
                cell?.counters = self.userCounters
                cell?.delegate = self
            }
            
            return cell!
        }
        return UITableViewCell.init()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section) {
        case 0: return 120;
        case 1: return 60;
        default:
            return 0
        }
    }
    
    func collectionCellPressedAtIndex(indexPath: IndexPath, keys: Array<String>) {
        if keys[indexPath.row] == "друзей" {
            self.performSegue(withIdentifier: "membersSegue", sender: self)
        } else if keys[indexPath.row] == "общих" {
            self.performSegue(withIdentifier: "mutualFriendsSegue", sender: self)
        } else if keys[indexPath.row] == "онлайн" {
            self.performSegue(withIdentifier: "onlineSegue", sender: self)
        } else if keys[indexPath.row] == "подписчиков" {
           //
        } else if keys[indexPath.row] == "групп" {
            //
        } else if keys[indexPath.row] == "фото" {
            //
        } else if keys[indexPath.row] == "видео" {
            //
        } else if keys[indexPath.row] == "аудио" {
            //
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "membersSegue" {
            
            let dest = segue.destination as! ViewController
            dest.userMain = userInformation
            dest.isAuthorized = true
        } else if segue.identifier == "onlineSegue" {
            let dest = segue.destination as! OnlineUsersTableViewController
            dest.userMain = userInformation
            dest.numberViewController = 0
        } else if segue.identifier == "mutualFriendsSegue" {
            let dest = segue.destination as! OnlineUsersTableViewController
            dest.userMain = userInformation
            dest.numberViewController = 1
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
