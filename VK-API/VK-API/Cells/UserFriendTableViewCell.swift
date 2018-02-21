//
//  UserFriendTableViewCell.swift
//  APITest_VK
//
//  Created by Андрей Фоменко on 16.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class UserFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var informationAboutUser: UILabel!
    @IBOutlet weak var allInformationAboutUser: UIButton!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var isOnline: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
