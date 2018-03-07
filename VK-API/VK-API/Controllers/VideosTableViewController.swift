//
//  VideoViewControllerTableViewController.swift
//  VK-API
//
//  Created by Андрей Фоменко on 06.03.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit
import Alamofire

class VideoTableViewController: UITableViewController {
    

    @IBOutlet var tableViewVideo: UITableView!
    var videosArray = Array<Video>()
    var videoInGroupArray = Array<VideoInGroup>()
    let manager = ServerManager.sharedManager()
    var userID: Int?
    var loadingData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Видеозаписи";
        self.view.backgroundColor = .white
        
        getVideoFromServer()
    }
    
    func getVideoFromServer() {
            
        manager.getVideoUsers(
            offset: videosArray.count,
            count: 30,
            userId: userID!,
            onSuccess: { (videos, videoInGroup) in
                if videos.count > 0 {
                    self.videosArray += videos
                    self.videoInGroupArray += videoInGroup
                    self.tableView.reloadData()
                    self.loadingData = false;
                }
                
        }) { (error: Error, statusCode: NSInteger) in
            print("error = \(error.localizedDescription), code = \(statusCode)")
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if !loadingData {
                loadingData = true
                getVideoFromServer()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videosArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "videosCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? VideosTableViewCell
        
        if (cell == nil) {
            cell = VideosTableViewCell.init(style: .default, reuseIdentifier: cellIdentifier)
        }
        let video = self.videosArray[indexPath.row]
        //let videoInGroup = self.videoInGroupArray[indexPath.row]
        if let name = video.title {
            cell?.nameLabel.text = name
        }
        if let group = video.descript {
            cell?.groupLabel.text = group
        }
        cell?.viewLabel.text = "\(video.views ?? 0) просмотров"
        
        var videoImageSize = ""
        if let videoImage = video.photo_640 {
            videoImageSize = videoImage
        } else if let videoImage = video.photo_320 {
            videoImageSize = videoImage
        } else if let videoImage = video.photo_130 {
            videoImageSize = videoImage
        }
        request(videoImageSize).response(completionHandler: { (response) in
            guard
                let data = response.data,
                let image = UIImage(data: data)
                else { return }
            
            cell?.imageVideo.image = image
        })
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
    
}

