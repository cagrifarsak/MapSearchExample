//
//  FavoriteItem.swift
//  MapSearchExample
//
//  Created by ÇAĞRI FARSAK on 19.10.2022.
//

import Foundation
import CoreLocation

struct FavoriteItem: Codable, Equatable {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}
