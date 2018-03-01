//
//  PhotosTableViewCell.swift
//  VK-API
//
//  Created by Андрей Фоменко on 28.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit
import Alamofire

class PhotosTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 0)
        layout.itemSize = CGSize.init(width: 100, height: 100)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 50, width: cellWidth(), height: 150), collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "colectionCell")
        collectionView?.backgroundColor = .clear
        
        albumNameLabel = UILabel.init(frame: CGRect.init(x: 15, y: 10, width: cellWidth(), height: 21))
        albumNameLabel.font = UIFont.systemFont(ofSize: 18)
        albumNameLabel.textColor = .black
        
        self.addSubview(albumNameLabel)
        
        albumPhotosCountLabel = UILabel.init(frame: CGRect.init(x: 15, y: 29, width: cellWidth(), height: 21))
 
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
                                    if photos.count > 0 {
                                        self.photoArray += photos
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colectionCell", for: indexPath)
        
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        cell.contentView.addSubview(imageView)
        
        let photo = self.photoArray[indexPath.row]
        
        request(photo.photo_130!).response(completionHandler: { (response) in
            guard
                let data = response.data,
                let image = UIImage(data: data)
                else { return }
            imageView.image = image
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView?.frame = CGRect.init(x: 0, y: 50, width: cellWidth(), height: 150)
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
