//
//  MapVC.swift
//  MainProject
//
//  Created by Chance Penner on 2/8/20.
//  Copyright © 2020 Big-Segfault-Energy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire


class MapVC: UIViewController {
 
var address = "haha"
var pincode = "haha"
var state = "haha"
var city = "haha"
var country = "haha"
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    @IBAction func locationTapped(_ sender: Any) {
        gotoPlaces()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        let cord2D = CLLocationCoordinate2D(latitude: (38.9543), longitude: (-95.2558))
        
         self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
        
    }
    
    func gotoPlaces() {
        txtSearch.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
       // lblocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
    }
}

extension MapVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
//         print("Place name: \(String(describing: place.name))")
        print("Place name: \(place.name ?? "")")
        dismiss(animated: true, completion: nil)
       
       self.mapView.clear()
       self.txtSearch.text = place.name
       
       /*
       let placeGmap = GoogleMapObjects()
       placeGmap.lat = place.coordinate.latitude
       placeGmap.long = place.coordinate.longitude
       placeGmap.address = place.name*/
       
       //self.delegate?.getThePlaceAddress(vc: self, place: placeGmap, tag: self.FieldTag)
   
        //DEBUG SECTION
print("Place Latitude: \(place.coordinate.latitude)")
print("Place Longitude: \(place.coordinate.longitude)")
        //DEBUG SECTION
        getAddressFromLatLong(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))

       let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        
                
       let marker = GMSMarker()
       marker.position =  cord2D
       marker.title = "Location"
       marker.snippet = place.name
       
       let markerImage = UIImage(named: "icon_offer_pickup")!
       let markerView = UIImageView(image: markerImage)
       marker.iconView = markerView
       marker.map = self.mapView
        
        
        
       self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyCQJO6u77UF8FLdqBps0JzA0jjbBdkLuWI"

        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                let responseJson = response.result.value! as! NSDictionary

                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                            self.address = results[0]["formatted_address"] as? String ?? ""
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
                                    if (temp[0] == "postal_code") {
                                        self.pincode = component["long_name"] as? String ?? ""
                                    }
                                    if (temp[0] == "locality") {
                                        self.city = component["long_name"] as? String ?? ""
                                    }
                                    if (temp[0] == "administrative_area_level_1") {
                                        self.state = component["long_name"] as? String ?? ""
                                    }
                                    if (temp[0] == "country") {
                                        self.country = component["long_name"] as? String ?? ""
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        print(address)
        print(pincode)
        print(city)
        print(state)
        print(country)
    }
    
}
