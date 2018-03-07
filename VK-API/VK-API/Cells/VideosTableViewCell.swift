//
//  VideosTableViewCell.swift
//  VK-API
//
//  Created by Андрей Фоменко on 07.03.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class VideosTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVideo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    
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
