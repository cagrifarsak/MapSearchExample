//
//  GooglePlacesManager.swift
//  MapSearchExample
//
//  Created by ÇAĞRI FARSAK on 18.10.2022.
//

import Foundation
import GooglePlaces
import CoreLocation


final class GooglePlacesManager {
    // MARK: - Singleton
    static let shared: GooglePlacesManager = GooglePlacesManager()
    
    private init() {}
    
    private let client = GMSPlacesClient.shared()
    
    
    /// Finds with query string and returns place array
    /// - Parameters:
    ///   - query: query string
    ///   - completion: Result<[Place], Error>
    public func findPlaces(query: String,
                           completion: @escaping (Result<[Place], Error>) -> Void ) {
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            
            let places: [Place] = results.compactMap({
                Place(
                    name: $0.attributedFullText.string,
                    identifier: $0.placeID
                )
            })
            
            completion(.success(places))
        }
    }
    
    /// Gets coordinates with place
    /// - Parameters:
    ///   - place: Place
    ///   - completion: Result<CLLocationCoordinate2D, Error>
    public func resolveLocation(
        for place: Place,
        completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void ) {
        
            client.fetchPlace(fromPlaceID: place.identifier,
                              placeFields: .coordinate,
                              sessionToken: nil) { googlePlace, error in
                guard let googlePlace = googlePlace, error == nil else {
                    completion(.failure(PlacesError.failedToGetCoordinates))
                    return
                }
                
                let coordinate = CLLocationCoordinate2D(
                    latitude: googlePlace.coordinate.latitude,
                    longitude: googlePlace.coordinate.longitude)
                
                completion(.success(coordinate))
            }
    }
}   

