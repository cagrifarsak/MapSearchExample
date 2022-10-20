//
//  MainViewController.swift
//  MapSearchExample
//
//  Created by ÇAĞRI FARSAK on 18.10.2022.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps


class MainViewController: UIViewController {
    var mapView = GMSMapView()
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    private let viewModel = MainViewModel()
    private var searchWorkItem: DispatchWorkItem?
    private var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        mapView.delegate = self
        viewModel.delegate = self
        navigationController?.navigationBar.tintColor = .black
        view.addSubview(mapView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0,
                               y: view.safeAreaInsets.top,
                               width: view.frame.size.width,
                               height: view.frame.size.height - view.safeAreaInsets.top)
        searchVC.searchBar.backgroundColor = .systemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
}

// MARK: - UISearchResultsUpdating Methods
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [unowned self] in
            guard let query = searchController.searchBar.text,
                  !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            self.searchController = searchController
            viewModel.updateSearchResults(query: query)
        }
        searchWorkItem = requestWorkItem
        
        guard let searchWorkItem = searchWorkItem else { return }
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3,
            execute: searchWorkItem
        )
    }
}

//MARK: - Delegate Functions
extension MainViewController: ResultsViewControllerDelegate {
    func didTapPlace(coordinates: CLLocationCoordinate2D, place: Place) {
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true)
        
        let camera = GMSCameraPosition.camera(
            withLatitude: coordinates.latitude,
            longitude: coordinates.longitude, zoom: 15.0
        )
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
        marker.title = place.name
        marker.map = mapView
    }
}

extension MainViewController: GMSMapViewDelegate {
    func mapView(_: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let storyboard = UIStoryboard(name: "DetailView", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController else { return true }
        detailVC.marker = marker
        navigationController?.pushViewController(detailVC, animated: true)
        return true
    }
}

// MARK: - Main View Model Delegate
extension MainViewController: MainViewModelDelegate {
    func placesFetched(_ places: [Place]) {
        guard let resultsVC = searchController?.searchResultsController as? ResultsViewController else { return }
        
        resultsVC.delegate = self
        DispatchQueue.main.async {
            resultsVC.update(places: places)
        }
    }
    
    func placesFetchedWithError(_ error: Error) {
        print(error)
    }
}
