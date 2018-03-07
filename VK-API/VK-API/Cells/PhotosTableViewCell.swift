//
//  PhotosTableViewCell.swift
//  VK-API
//
//  Created by Андрей Фоменко on 28.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit
import Alamofire

class PhotosTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var photoArray = Array<Photo>()
    var albumNameLabel = UILabel()
    var albumPhotosCountLabel = UILabel()
    var album = Album()
    var delegate : CountersDelegate?
    var collectionView : UICollectionView?
    var loadingData = true
    let manager = ServerManager.sharedManager()
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, album : Album) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize.init(width: 0, height: 0)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 60, width: cellWidth(), height: 100), collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "photosIdentifier")
        collectionView?.backgroundColor = .clear
        
        albumNameLabel = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: cellWidth(), height: 20))
        albumNameLabel.font = UIFont.systemFont(ofSize: 18)
        albumNameLabel.textColor = .black
        
        self.addSubview(albumNameLabel)
        
        albumPhotosCountLabel = UILabel.init(frame: CGRect.init(x: 15, y: 30, width: cellWidth(), height: 20))
 
        albumPhotosCountLabel.font = UIFont.systemFont(ofSize: 15)
        albumPhotosCountLabel.textColor = .gray
        self.addSubview(albumPhotosCountLabel)
        
        self.contentView.addSubview(self.collectionView!)
        self.album = album
        loadingData = true
        getPhotosFromServer()
    }
    
    func getPhotosFromServer() {
        manager.getPhotosFromAlbum(offset: photoArray.count,
                                   count: 20,
                                   userId: album.ownerID!,
                                   albumId: album.id!,
                                   onSuccess: { (photos) in
            if (photos?.count)! > 0 {
                self.photoArray += photos!
                self.collectionView?.reloadData()
                self.loadingData = false
            }
        }) { (error: Error, statusCode: NSInteger) in
            print("error = \(error.localizedDescription), code = \(statusCode)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosIdentifier", for: indexPath)

        let photo = self.photoArray[indexPath.row]
        var photo_zise = ""
        
        if let ph = photo.photo_1280 {
            photo_zise = ph
        } else if let ph = photo.photo_807 {
            photo_zise = ph
        } else if let ph = photo.photo_604 {
            photo_zise = ph
        } else if let ph = photo.photo_130 {
            photo_zise = ph
        } else if let ph = photo.photo_75 {
            photo_zise = ph
        }
        
        request(photo_zise).response(completionHandler: { (response) in
            guard
                let data = response.data,
                let image = UIImage(data: data)
                else { return }

            cell.backgroundView = UIImageView.init(image: image)
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.collectionCellPressedAtIndex(indexPath: indexPath, keys: ["фото"])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if !loadingData {
                loadingData = true
                getPhotosFromServer()
            }
        }
    }
    
   func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = self.photoArray[indexPath.row]
        var size : Double = 1
        if photo.width != nil && photo.height != nil {
            size = Double(photo.width! / photo.height!)
        }
        return CGSize.init(width: 100 * size, height: 100)
    }
    
    func cellWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
