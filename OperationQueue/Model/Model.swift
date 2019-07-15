//
//  Model.swift
//  OperationQueue
//
//  Created by NP2 on 7/15/19.
//  Copyright © 2019 shndrs. All rights reserved.
//

import UIKit

public struct Model {
    
    public private(set) var image: UIImage?
    public private(set) var title: String?
    
    public init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
}
