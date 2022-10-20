//
//  MainViewModel.swift
//  MapSearchExample
//
//  Created by ÇAĞRI FARSAK on 19.10.2022.
//

import Foundation
import GooglePlaces

protocol MainViewModelDelegate: AnyObject {
    func placesFetched(_ places: [Place])
    func placesFetchedWithError(_ error: Error)
}

class MainViewModel {
    // MARK: - Parameters
    weak var delegate: MainViewModelDelegate?
    
    /// Updates when search result triggers
    /// - Parameter query: Search query text
    func updateSearchResults(query: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        GMSPlacesClient.shared().findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: nil) { [weak self] results, error in
                guard let self = self else { return }
                guard let results = results, error == nil else {
                    self.delegate?.placesFetchedWithError(PlacesError.failedToFind)
                    return
                }
                
                let places: [Place] = results.compactMap({
                    Place(
                        name: $0.attributedFullText.string,
                        identifier: $0.placeID
                    )
                })
    
                self.delegate?.placesFetched(places)
            }
    }
}
