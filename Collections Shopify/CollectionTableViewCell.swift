//
//  CollectionTableViewCell.swift
//  Collections Shopify
//
//  Created by Charles Zhang on 2019-01-20.
//  Copyright © 2019 Charles Zhang. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var collectionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
