//
//  ResultsViewModel.swift
//  MapSearchExample
//
//  Created by ÇAĞRI FARSAK on 20.10.2022.
//

import Foundation
import GooglePlaces
import CoreLocation

protocol ResultsViewModelDelegate: AnyObject {
    func placesResolved(_ coordinates: CLLocationCoordinate2D, _ place: Place)
    func placesResolvedWithError(_ error: Error)
}

class ResultsViewModel {
    // MARK: - Parameters
    weak var delegate: ResultsViewModelDelegate?
    
    /// Resolves when search result
    /// - Parameter place: Place
    func resolveLocation(_ place: Place) {
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self?.delegate?.placesResolved(coordinate, place)
                }
            case .failure(let error):
                self?.delegate?.placesResolvedWithError(error)
            }
        }
    }
}
