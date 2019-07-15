//
//  TableViewCell.swift
//  OperationQueue
//
//  Created by NP2 on 7/15/19.
//  Copyright © 2019 shndrs. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var bannerImage: UIImageView! {
        didSet {
            let cr = bannerImage.bounds.width/2
            bannerImage.layer.cornerRadius = cr
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func fillCellBy(title:String?, imageURL:URL) {
        
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        guard let unfilteredImage = UIImage(data: imageData) else { return }
        let filterdImage = FilterImage.applySepiaFilter(unfilteredImage)
        
        titleLabel.text = title
        bannerImage.image = filterdImage
    }
}
