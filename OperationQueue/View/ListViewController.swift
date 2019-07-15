//
//  ListViewController.swift
//  OperationQueue
//
//  Created by NP2 on 7/15/19.
//  Copyright © 2019 shndrs. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    private lazy var photos: Array<PhotoRecord> = {
        return Array<PhotoRecord>()
    }()
    private let pendingOperations = PendingOperations()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: Strings.cellId.rawValue, bundle: nil),
                               forCellReuseIdentifier: Strings.cellId.rawValue)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 80
            
        }
    }
}

// MARK: - Life Cycle

extension ListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Strings.operationQueueEx.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Methods

extension ListViewController {
    func fetchPhotoDetails() {
        let request = URLRequest(url: DataSource.url)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            
            let alertController = UIAlertController(title: Strings.oops.rawValue,
                                                    message: Strings.fetchError.rawValue,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: Strings.ok.rawValue, style: .default)
            alertController.addAction(okAction)
            
            if let data = data {
                do {
                    
                    let datasourceDictionary =
                        try PropertyListSerialization.propertyList(from: data,
                                                                   options: [],
                                                                   format: nil) as! [String: String]
                    
                    for (name, value) in datasourceDictionary {
                        let url = URL(string: value)
                        if let url = url {
                            let photoRecord = PhotoRecord(name: name, url: url)
                            self.photos.append(photoRecord)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.tableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }

}

// MARK: TableView DataSource Delegate

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellId.rawValue) as! TableViewCell
        
        let rowKey = photos.allKeys[indexPath.row] as! String
        guard let imageURL = URL(string:photos[rowKey] as! String) else { return cell }
        cell.fillCellBy(title: rowKey, imageURL: imageURL)
        return cell
    }
}
