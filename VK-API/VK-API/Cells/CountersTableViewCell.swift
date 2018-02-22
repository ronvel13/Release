//
//  CountersTableViewCell.swift
//  VK-API
//
//  Created by Андрей Фоменко on 21.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class CountersTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var counters = UserCounters()
    var countCell = 0
    var flag = [false, false, false, false, false, false, false]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumInteritemSpacing = 2.f;
        layout.minimumLineSpacing = 4.0
        
        let insets = UIEdgeInsetsMake(0, 2, 0, 2)
        layout.sectionInset = insets
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: cellWidth(), height: 44), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "colectionCell")
        collectionView.backgroundColor = .clear
            
        self.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        countCell += counters.audios        != nil && counters.audios        != 0 ? 1 : 0
        countCell += counters.followers     != nil && counters.followers     != 0 ? 1 : 0
        countCell += counters.friends       != nil && counters.friends       != 0 ? 1 : 0
        countCell += counters.groups        != nil && counters.groups        != 0 ? 1 : 0
        countCell += counters.mutualFriends != nil && counters.mutualFriends != 0 ? 1 : 0
        countCell += counters.onlineFriends != nil && counters.onlineFriends != 0 ? 1 : 0
        countCell += counters.photos        != nil && counters.photos        != 0 ? 1 : 0
        countCell += counters.videos        != nil && counters.videos        != 0 ? 1 : 0
        
        return countCell - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let counerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colectionCell", for: indexPath)
        
        counerCell.backgroundColor = .clear
        
        let nameLabel = UILabel.init(frame: CGRect(x: 0, y: 30, width: 80, height: 20))
        let countLabel = UILabel.init(frame: CGRect(x: 0, y: 10, width: 80, height: 20))
        
        nameLabel.textAlignment = .center
        countLabel.textAlignment = .center
        
        nameLabel.textColor = .gray
        countLabel.textColor = .black
        
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        countLabel.font = UIFont.systemFont(ofSize: 18)
        
        counerCell.addSubview(nameLabel)
        counerCell.addSubview(countLabel)
        
        nameLabel.text = nil
        if counters.friends != nil {
            switch indexPath.row {
            case 0:
                if self.counters.friends != nil && self.counters.friends != 0 && !flag[0] {
                    nameLabel.text = "друзей"
                    countLabel.text = String(describing: self.counters.friends!)
                    flag[0] = true
                    break
                }
                fallthrough
            case 1:
                if self.counters.mutualFriends != nil && self.counters.mutualFriends != 0 && !flag[1] {
                    nameLabel.text = "общих"
                    countLabel.text = String(describing: self.counters.mutualFriends!)
                    flag[1] = true
                    break
                }
                fallthrough
            case 2:
                if self.counters.followers != nil && self.counters.followers != 0 && !flag[2] {
                    nameLabel.text = "подписчиков"
                    countLabel.text = String(describing: self.counters.followers!)
                    flag[2] = true
                    break
                }
                fallthrough
            case 3:
                if self.counters.groups != nil && self.counters.groups != 0 && !flag[3] {
                    nameLabel.text = "групп"
                    countLabel.text = String(describing: self.counters.groups!)
                    flag[3] = true
                    break
                }
                fallthrough
            case 4:
                if self.counters.photos != nil && self.counters.photos != 0 && !flag[4] {
                    nameLabel.text = "фото"
                    countLabel.text = String(describing: self.counters.photos!)
                    flag[4] = true
                    break
                }
                fallthrough
            case 5:
                if self.counters.videos != nil && self.counters.videos != 0 && !flag[5] {
                    nameLabel.text = "видео"
                    countLabel.text = String(describing: self.counters.videos!)
                    flag[5] = true
                    break
                }
                fallthrough
            case 6:
                if self.counters.audios != nil && self.counters.audios != 0 && !flag[6] {
                    nameLabel.text = "аудио"
                    countLabel.text = String(describing: self.counters.audios!)
                    flag[6] = true
                    break
                }
                fallthrough
            default:
                break
            }
        }
        return counerCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 50)
    }
    
    func cellWidth() -> CGFloat {
    return UIScreen.main.bounds.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        //super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
