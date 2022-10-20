//
//  FavoriteViewController.swift
//  MapSearchExample
//
//  Created by ÇAĞRI FARSAK on 19.10.2022.
//

import Foundation
import UIKit


class FavoriteViewController: UIViewController {
        
    private let tableview: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var favorites: [FavoriteItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
}

//MARK: - Methods
extension FavoriteViewController {
    private func initialize() {
        title = "Favorites"
        view.addSubview(tableview)
        view.backgroundColor = .clear
        tableview.delegate = self
        tableview.dataSource = self
    }
}

//MARK: - Tableview Functions
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = favorites[indexPath.row].name
        return cell
    }
}
