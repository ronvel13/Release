//
//  ViewController.swift
//  APITest_VK
//
//  Created by Андрей Фоменко on 10.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UITableViewController {

    var friends = Array<Person>()
    let friendsInRequest = 50
    var loadingData = true
    var userMain = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingData = true
        var manager = ServerManager()
        manager.authorizeUser(user: userMain, completion: { (token) in
            print("AUTHORIZED!");
            self.getFriendsFromServer()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFriendsFromServer() {
        
        let manager = ServerManager.sharedManager()
        
        manager.getFriendsWithOffset(offset: friends.count,
            count: friendsInRequest,
            onSuccess: { (friends) in
                self.friends += friends
                if friends.count > 0 {
                    self.tableView.reloadData()
                    /*var newPaths = [IndexPath]()
                    
                    for i in (self.friends.count - friends.count)..<self.friends.count {
                        newPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: newPaths, with: .fade)
                    self.tableView.endUpdates()*/
                    self.loadingData = false
                }
            
        }) { (error: Error, statusCode: NSInteger) in
            print("error = \(error.localizedDescription), code = \(statusCode)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = friends[indexPath.row].firstName + " " + friends[indexPath.row].lastName
        
        request(friends[indexPath.row].photo_50!).response(completionHandler: { (response) in
            guard
                let data = response.data,
                let image = UIImage(data: data)
                else { return }
            
            cell?.imageView?.image = image
            
            let imageLayer = cell?.imageView?.layer;
            imageLayer?.cornerRadius = 25
            //imageLayer?.borderWidth = 1
            //imageLayer?.borderColor = UIColor.gray.cgColor
            imageLayer?.masksToBounds = true

            cell?.layoutSubviews()
        })
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "PersonMain", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if !loadingData {
                loadingData = true
                getFriendsFromServer()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "PersonMain") {
            
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let friend = self.friends[(indexPath?.row)!]
            let dest : PersonWallTableViewController = segue.destination as! PersonWallTableViewController
            dest.userID = friend.user_id
        }
    }
    
    deinit {
        tableView.delegate = nil
    }
}

