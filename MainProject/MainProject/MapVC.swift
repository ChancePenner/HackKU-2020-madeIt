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

var currentLatitude = 0.0
var currentLongitude = 0.0
var currentLocationName = ""
var destinationLocationName = ""
var destinationLatitude = 0.0
var destinationLongitude = 0.0
var distanceInMeters = 0.0
var distanceInMiles = 0.0


class MapVC: UIViewController {
 

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var distanceTracker: UILabel!
    
    @IBAction func locationTapped(_ sender: Any) {
        gotoPlaces()
    }
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        let cord2D = CLLocationCoordinate2D(latitude: (38.958066723838634), longitude: (-95.25361727619011))
        
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
    
    
    func getRouteSteps(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {

        let session = URLSession.shared

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyCQJO6u77UF8FLdqBps0JzA0jjbBdkLuWI")!

        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in

            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {

                print("error in JSONSerialization")
                return

            }



            guard let routes = jsonResult["routes"] as? [Any] else {
                return
            }

            guard let route = routes[0] as? [String: Any] else {
                return
            }

            guard let legs = route["legs"] as? [Any] else {
                return
            }

            guard let leg = legs[0] as? [String: Any] else {
                return
            }

            guard let steps = leg["steps"] as? [Any] else {
                return
            }
              for item in steps {

                guard let step = item as? [String: Any] else {
                    return
                }

                guard let polyline = step["polyline"] as? [String: Any] else {
                    return
                }

                guard let polyLineString = polyline["points"] as? String else {
                    return
                }

                //Call this method to draw path on map
                DispatchQueue.main.async {
                    self.drawPath(from: polyLineString)
                }

            }
        })
        task.resume()
    }
    
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView


        let currentZoom = mapView.camera.zoom
        mapView.animate(toZoom: currentZoom - 1.4)
    }


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
        sentMessage = false //reinitialize to false
//         print("Place name: \(String(describing: place.name))")
        print("Place name: \(place.name ?? "")")
        destinationLocationName = (place.name ?? "")
        dismiss(animated: true, completion: nil)
       
       self.mapView.clear()
       self.txtSearch.text = place.name
        destinationLatitude = place.coordinate.latitude
        destinationLongitude = place.coordinate.longitude
        
        
       /*
       let placeGmap = GoogleMapObjects()
       placeGmap.lat = place.coordinate.latitude
       placeGmap.long = place.coordinate.longitude
       placeGmap.address = place.name*/
       
       //self.delegate?.getThePlaceAddress(vc: self, place: placeGmap, tag: self.FieldTag)
   

print("Place Latitude: \(destinationLatitude)")
print("Place Longitude: \(destinationLongitude)")

       
        
       let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        
        
    let marker1 = GMSMarker()
      marker1.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
//        marker1.title = "TESTING"
//    marker1.snippet = "HangZhou"
    marker1.map = mapView
      
    let marker2 = GMSMarker()
//      marker2.position = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
        marker2.position = cord2D
    marker2.title = destinationLocationName
//    marker2.snippet = destinationLocationName
    marker2.map = mapView
      getRouteSteps(from:marker1.position, to:marker2.position)
        
        let coordinate1 = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        let coordinate2 = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        distanceInMeters = coordinate2.distance(from: coordinate1)
        
        distanceInMiles = distanceInMeters * 0.000621371
        
        print(String(format: "%1f", distanceInMiles))
        
        let distanceString = (String(format: "%.1f", distanceInMiles) + "mi")
        print(distanceString)
        self.distanceTracker.text = distanceString
        print("distance is: ")
//        self.distanceTracker.text = (self.distanceTracker.text ?? "")
        print(self.distanceTracker.text ?? "")
        
                
//       let marker = GMSMarker()
//       marker.position =  cord2D
//       marker.title = "Location"
//       marker.snippet = place.name
//
//       let markerImage = UIImage(named: "icon_offer_pickup")!
//       let markerView = UIImageView(image: markerImage)
//       marker.iconView = markerView
//       marker.map = self.mapView
        
        
        
       self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
