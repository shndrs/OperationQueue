//
//  ListViewController.swift
//  OperationQueue
//
//  Created by NP2 on 7/15/19.
//  Copyright © 2019 shndrs. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    private lazy var photos = NSDictionary(contentsOf:DataSource.url)!
    
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
