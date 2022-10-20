//
//  MapSearchExampleTests.swift
//  MapSearchExampleTests
//
//  Created by ÇAĞRI FARSAK on 18.10.2022.
//

import XCTest

@testable import MapSearchExample
@testable import GoogleMaps

class MapSearchExampleTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private var controller = DetailViewController()
    private var testMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 10, longitude: 10))
    private var secondTestMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 15, longitude: 15))
    
    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: "testSuite")
        userDefaults.removePersistentDomain(forName: "testSuite")
        controller.defaults = userDefaults
    }
    
    func testUserDefaultsKeys() {
        XCTAssertEqual(UserDefaultsKeys.favoriteItems.rawValue, "FavoriteItems")
    }
    
    func testAddFavorite() {
        let favoriteAddTestItemsCount = controller.myFavoriteItems.count
        testMarker.title = "TEST"
        controller.marker = testMarker
        controller.addFavorite()
        XCTAssertEqual(favoriteAddTestItemsCount + 1, controller.myFavoriteItems.count)
    }
    
    func testRemoveFavorite() {
        secondTestMarker.title = "TEST2"
        controller.marker = secondTestMarker
        controller.addFavorite()
        testMarker.title = "TEST"
        controller.marker = testMarker
        controller.addFavorite()
        
        let favoriteRemoveTestItemsCount = controller.myFavoriteItems.count
        controller.removeFavorite()
        XCTAssertEqual(favoriteRemoveTestItemsCount - 1, controller.myFavoriteItems.count)
    }
    
}
