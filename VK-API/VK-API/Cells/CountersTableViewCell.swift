//
//  CountersTableViewCell.swift
//  VK-API
//
//  Created by Андрей Фоменко on 21.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class CountersTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var delegate : CountersDelegate?
    var counters = UserCounters()
    var countCell = 0
    var flag = [false, false, false, false, false, false, false, false]
    var keyCounters = Array<String>()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumInteritemSpacing = 2.f;
        layout.minimumLineSpacing = 4.0
        
        let insets = UIEdgeInsetsMake(0, 2, 0, 2)
        layout.sectionInset = insets
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: cellWidth(), height: 50), collectionViewLayout: layout)
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
        
        return countCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let counerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colectionCell", for: indexPath)
        
        counerCell.backgroundColor = .clear
        
        let nameLabel = UILabel.init(frame: CGRect(x: 0, y: 34, width: 80, height: 13))
        let countLabel = UILabel.init(frame: CGRect(x: 0, y: 14, width: 80, height: 15))
        
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
                    keyCounters.append("друзей")
                    flag[0] = true
                    break
                }
                fallthrough
            case 1:
                if self.counters.mutualFriends != nil && self.counters.mutualFriends != 0 && !flag[1] {
                    nameLabel.text = "общих"
                    countLabel.text = String(describing: self.counters.mutualFriends!)
                    keyCounters.append("общих")
                    flag[1] = true
                    break
                }
                fallthrough
            case 2:
                if self.counters.friends != nil && self.counters.friends != 0 && !flag[2] {
                    nameLabel.text = "онлайн"
                    countLabel.text = String(describing: self.counters.onlineFriends!)
                    keyCounters.append("онлайн")
                    flag[2] = true
                    break
                }
                fallthrough
            case 3:
                if self.counters.followers != nil && self.counters.followers != 0 && !flag[3] {
                    nameLabel.text = "подписчиков"
                    countLabel.text = String(describing: self.counters.followers!)
                    keyCounters.append("подписчиков")
                    flag[3] = true
                    break
                }
                fallthrough
            case 4:
                if self.counters.groups != nil && self.counters.groups != 0 && !flag[4] {
                    nameLabel.text = "групп"
                    countLabel.text = String(describing: self.counters.groups!)
                    keyCounters.append("групп")
                    flag[4] = true
                    break
                }
                fallthrough
            case 5:
                if self.counters.photos != nil && self.counters.photos != 0 && !flag[5] {
                    nameLabel.text = "фото"
                    countLabel.text = String(describing: self.counters.photos!)
                    keyCounters.append("фото")
                    flag[5] = true
                    break
                }
                fallthrough
            case 6:
                if self.counters.videos != nil && self.counters.videos != 0 && !flag[6] {
                    nameLabel.text = "видео"
                    countLabel.text = String(describing: self.counters.videos!)
                    keyCounters.append("видео")
                    flag[6] = true
                    break
                }
                fallthrough
            case 7:
                if self.counters.audios != nil && self.counters.audios != 0 && !flag[7] {
                    nameLabel.text = "аудио"
                    countLabel.text = String(describing: self.counters.audios!)
                    keyCounters.append("аудио")
                    flag[7] = true
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
        return CGSize.init(width: 80, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.delegate?.collectionCellPressedAtIndex(indexPath: indexPath, keys: keyCounters)
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
    
    deinit {
        self.delegate = nil
    }

}
