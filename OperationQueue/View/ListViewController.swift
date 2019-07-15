//
//  ListViewController.swift
//  OperationQueue
//
//  Created by NP2 on 7/15/19.
//  Copyright © 2019 shndrs. All rights reserved.
//

import UIKit
import CoreImage

final class ListViewController: UIViewController {
    
    lazy var photos = NSDictionary(contentsOf:DataSource.url)!
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: Strings.cellId.rawValue, bundle: nil),
                               forCellReuseIdentifier: Strings.cellId.rawValue)
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    }
    
    private func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:image.pngData()!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:Strings.sepiaTone.rawValue)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: Strings.inputIntensity.rawValue)
        
        guard let outputImage = filter!.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        return UIImage(cgImage: outImage)
    }
    
}

// MARK: - Life Cycle

extension ListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: TableView DataSource Delegate

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellId.rawValue) as! TableViewCell
        
        return UITableViewCell()
    }
}
