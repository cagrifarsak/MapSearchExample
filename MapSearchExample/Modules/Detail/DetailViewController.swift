//
//  DetailViewController.swift
//  MapSearchExample
//
//  Created by ÇAĞRI FARSAK on 19.10.2022.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var vwGoFavorite: UIView!
    
    var isFavorite = false
    var marker = GMSMarker()
    var myFavoriteItems = [FavoriteItem]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Place Detail"
        vwGoFavorite.layer.cornerRadius = 10
        getFavoriteItems()
        setFavoriteImage(self.marker)
        setUI(self.marker)
    }
    
    @IBAction func btnGoFavoriteAction(_ sender: Any) {
        let favoriteVC = FavoriteViewController()
        favoriteVC.favorites = myFavoriteItems
        self.navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    @IBAction func btnAddFavoriteAction(_ sender: Any) {
        if isFavorite {
            removeFavorite()
            isFavorite = false
            imgFavorite.image = UIImage(named: ImageNames.favoriteImageEmpty.rawValue)
        } else {
            addFavorite()
            isFavorite = true
            imgFavorite.image = UIImage(named: ImageNames.favoriteImageFill.rawValue)
        }
    }
}

// MARK: - Private Methods
extension DetailViewController {
    
    /// Sets labels text
    /// - Parameter marker: GMSMarker
    private func setUI(_ marker: GMSMarker) {
        lblTitle.text = marker.title
        lblLatitude.text = "Latitude: \(marker.position.latitude)"
        lblLongitude.text = "Longitude: \(marker.position.longitude)"
    }

    /// Gets favori items at user defaults
    private func getFavoriteItems() {
        if let data = defaults.object(forKey: UserDefaultsKeys.favoriteItems.rawValue) as? Data,
           let favoriteArray = try? JSONDecoder().decode([FavoriteItem].self, from: data) {
            myFavoriteItems = favoriteArray
        } else {
            myFavoriteItems = []
        }
    }
    
    /// Add favorite item at user defaults
    public func addFavorite() {
        guard let title = self.marker.title else { return }
        let favoriteItem = FavoriteItem(name: title, latitude: marker.position.latitude, longitude: marker.position.longitude)
        myFavoriteItems.append(favoriteItem)
        if let encoded = try? JSONEncoder().encode(myFavoriteItems) {
            defaults.set(encoded, forKey: UserDefaultsKeys.favoriteItems.rawValue)
            defaults.synchronize()
        }
    }
    
    /// Remove favorite item at user defaults
    public func removeFavorite() {
        guard let title = self.marker.title else { return }
        let favoriteItem = FavoriteItem(name: title, latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        
        myFavoriteItems = myFavoriteItems.filter({
            return $0 != favoriteItem
        })

        if let encoded = try? JSONEncoder().encode(myFavoriteItems) {
            defaults.set(encoded, forKey: UserDefaultsKeys.favoriteItems.rawValue)
            defaults.synchronize()
        }
    }
    
    /// Sets favorite image
    /// - Parameter marker: GMSMarker
    private func setFavoriteImage(_ marker: GMSMarker) {
        isFavorite = false
        for favoriteItem in myFavoriteItems {
            if favoriteItem.latitude == marker.position.latitude, favoriteItem.longitude == marker.position.longitude {
                isFavorite = true
            }
        }
        
        if isFavorite {
            imgFavorite.image = UIImage(named: ImageNames.favoriteImageFill.rawValue)
        } else {
            imgFavorite.image = UIImage(named: ImageNames.favoriteImageEmpty.rawValue)
        }
    }
}

