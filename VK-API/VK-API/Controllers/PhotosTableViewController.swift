//
//  PhotosTableViewController.swift
//  VK-API
//
//  Created by Андрей Фоменко on 28.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {
    
    var albumArray = Array<Album>()
    var countAlbums = 0
    let manager = ServerManager.sharedManager()
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Фотографии";
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.refreshControl = refresh
        self.tableView.separatorColor = .clear
      
        getAlbumsFromServer()
    }
    
    @objc func refreshPage() {
        manager.getAlbumsById(userId: userID!,
                              onSuccess: { (albumArray) in
                                if albumArray.count > 0 {
                                    self.albumArray.removeAll()
                                    self.albumArray = albumArray
                                    self.refreshControl?.endRefreshing()
                                    self.tableView.reloadData()
                                } else {
                                    self.refreshControl?.endRefreshing()
                                }
        }) { (error: Error, statusCode: NSInteger) in
            print("error = \(error.localizedDescription), code = \(statusCode)")
        }
    }
    
    
    func getAlbumsFromServer() {
        manager.getAlbumsById(userId: userID!,
                              onSuccess: { (albumArray) in
            if albumArray.count > 0 {
                var del = Array<Int>()
                self.albumArray = albumArray
                for i in 0..<self.albumArray.count {
                    if self.albumArray[i].size == 0 {
                        del.append(i)
                    }
                }
                for d in del {
                    self.albumArray.remove(at: d)
                }
                self.tableView.reloadData()
            }
        }) { (error: Error, statusCode: NSInteger) in
            print("error = \(error.localizedDescription), code = \(statusCode)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.albumArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cellIdentifier = "photosIdentifier"
        
        let album = self.albumArray[indexPath.row]
        
        //var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PhotosTableViewCell
        
        //if (cell == nil) {
            let cell = PhotosTableViewCell.init(style: .default, reuseIdentifier: cellIdentifier, album: album)
        //}
        cell.albumNameLabel.text = album.title
        cell.albumPhotosCountLabel.text = "\(album.size!) фото"

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "detailCollectionSegue", sender: indexPath)
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailCollectionSegue") {
            
            let indexPath = sender as? IndexPath
            
            let album = self.albumArray[(indexPath?.row)!]
            //let dest = segue.destination as! DetailCollectionViewController

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

}
