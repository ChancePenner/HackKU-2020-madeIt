//
//  MainMenu.swift
//  MainProject
//
//  Created by Markus Becerra on 2/8/20.
//  Copyright © 2020 Big-Segfault-Energy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Foundation
import Alamofire
var sentMessage = false
var sendMessage = true
var userName = "Markus"
class MainMenu: UIViewController {
    let locationManager = CLLocationManager()
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
          getCurrentLocation()
          
         
      }
      
      func getCurrentLocation() {
          self.locationManager.requestAlwaysAuthorization()
          
          self.locationManager.requestWhenInUseAuthorization()
          
          if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = (self as CLLocationManagerDelegate)
              locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
              locationManager.startUpdatingLocation()
          }
      }
      
      func haveArrived() -> Bool {
          if((currentLatitude <= destinationLatitude + 0.2 && currentLatitude >= destinationLatitude - 0.2) && (currentLongitude <= destinationLongitude + 0.2 && currentLongitude >= destinationLongitude - 0.2))
          {
              return true;
          }
          else{
              return false;
          }
      }
   }
   
extension MainMenu: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:
        [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentLatitude = locValue.latitude
        currentLongitude = locValue.longitude
        sendMessage = haveArrived()
        
        if(sendMessage && !sentMessage)
        {
            print("WE IN BOIS")
            let accountSID = "ACd966c500021c1c1bdb998330b07a4df1"
            let authToken = "bd5822b62c442172a31403f7ee6d19aa"
                print("im here setting stuff up")
                          let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
                           let parameters = ["From": "+18065471980", "To": "9133134958", "Body": "\(userName) made it to \(destinationLocationName)!!!"]
                 
                           Alamofire.request(url, method: .post, parameters: parameters)
                             .authenticate(user: accountSID, password: authToken)
                             .responseJSON { response in
                               debugPrint(response)
                               
                           }

                         
            print("true")
            sentMessage = true
        }
    print(sendMessage)
    }
    
}


    
    
    
//    @IBOutlet weak var google_map: GMSMapView!
//
//
//
//    // You don't need to modify the default init(nibName:bundle:) method.
//
//    override func loadView() {
//      // Create a GMSCameraPosition that tells the map to display the
//      // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//
//
//       google_map.camera = camera
//        self.show_marker(position: google_map.camera.target)
//        self.google_map.delegate = self
////      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
////      view = mapView
//
//      // Creates a marker in the center of the map.
////      let marker = GMSMarker()
////      mapView.isMyLocationEnabled = true
////      marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
////      marker.title = "Sydney"
////      marker.snippet = "Australia"
////      marker.map = mapView
//    }
//
//    func show_marker(position : CLLocationCoordinate2D) {
//
//        let marker = GMSMarker()
//        marker.position = position
//        marker.title = "Title test"
//        marker.snippet = "Snippet test"
//        marker.map = google_map
//    }
//
//}
//
//extension ViewController: GMSMapViewDelegate {
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
//    {
//        print("Clicked on Marker")
//    }



    







