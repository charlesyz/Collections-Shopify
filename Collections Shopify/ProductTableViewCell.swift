//
//  productTableViewCell.swift
//  Collections Shopify
//
//  Created by Charles Zhang on 2019-01-20.
//  Copyright © 2019 Charles Zhang. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockNumber: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
