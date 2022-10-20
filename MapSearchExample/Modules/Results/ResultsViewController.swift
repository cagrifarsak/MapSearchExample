//
//  ResultsViewController.swift
//  MapSearchExample
//
//  Created by ÇAĞRI FARSAK on 18.10.2022.
//

import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(coordinates: CLLocationCoordinate2D, place: Place)
}

class ResultsViewController: UIViewController {
        
    private let tableview: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let viewModel = ResultsViewModel()
    weak var delegate: ResultsViewControllerDelegate?
    
    private var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
    
    /// Updates table view with new places
    /// - Parameter places: [Place]
    func update(places: [Place]) {
        self.tableview.isHidden = false
        self.places = places
        tableview.reloadData()
    }
}

//MARK: - Methods
extension ResultsViewController {
    private func initialize() {
        view.addSubview(tableview)
        view.backgroundColor = .clear
        viewModel.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
    }
}

//MARK: Tableview Functions
extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = places[indexPath.row]
        tableView.isHidden = true
        viewModel.resolveLocation(place)
    }
}

extension ResultsViewController: ResultsViewModelDelegate {
    func placesResolved(_ coordinates: CLLocationCoordinate2D, _ place: Place) {
        self.delegate?.didTapPlace(coordinates: coordinates, place: place)
    }
    
    func placesResolvedWithError(_ error: Error) {
        print(error)
    }
}
