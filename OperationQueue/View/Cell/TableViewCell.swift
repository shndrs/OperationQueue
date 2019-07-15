//
//  TableViewCell.swift
//  OperationQueue
//
//  Created by NP2 on 7/15/19.
//  Copyright © 2019 shndrs. All rights reserved.
//

import UIKit

protocol ReloadTableDelegate: AnyObject {
    func reloadTable(at indexPath:IndexPath)
}

final class TableViewCell: UITableViewCell {
    
    private let pendingOperations = PendingOperations()
    
    public weak var reloadDelegate: ReloadTableDelegate?
    
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
    
    private func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        switch (photoRecord.state) {
        case .new:
            startDownload(for: photoRecord, at: indexPath)
        case .downloaded:
            startFiltration(for: photoRecord, at: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    private func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        let downloader = ImageDownloader(photoRecord)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.reloadDelegate?.reloadTable(at: indexPath)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFiltration(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        guard pendingOperations.filtrationsInProgress[indexPath] == nil else {
            return
        }
        
        let filterer = ImageFilteration(photoRecord)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
                self.reloadDelegate?.reloadTable(at: indexPath)
            }
        }
        
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }

    
    public func fillCellBy(photoRecord: PhotoRecord, indexPath: IndexPath) {

        if self.accessoryView == nil {
            let indicator = UIActivityIndicatorView(style: .gray)
            self.accessoryView = indicator
        }
        let indicator = self.accessoryView as! UIActivityIndicatorView
        
        titleLabel.text = photoRecord.name
        bannerImage.image = photoRecord.image
        
        switch (photoRecord.state) {
        case .filtered:
            indicator.stopAnimating()
        case .failed:
            indicator.stopAnimating()
            self.titleLabel?.text = Strings.failedToLoad.rawValue
        case .new, .downloaded:
            indicator.startAnimating()
            startOperations(for: photoRecord, at: indexPath)
        }
    }
}
