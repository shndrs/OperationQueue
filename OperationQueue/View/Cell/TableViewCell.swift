//
//  TableViewCell.swift
//  OperationQueue
//
//  Created by NP2 on 7/15/19.
//  Copyright © 2019 shndrs. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var bannerImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func fill(cell by:Model) {
        bannerImage.image = by.image
        titleLabel.text = by.title
    }
    
}
