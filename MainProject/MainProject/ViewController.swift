//
//  ViewController.swift
//  MainProject
//
//  Created by Chance Penner on 2/8/20.
//  Copyright © 2020 Big-Segfault-Energy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

 let camera = GMSCameraPosition.camera(withLatitude: 30.173226, longitude: 120.269337, zoom: 16.0)
let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

class ViewController: UIViewController {

    // You don't need to modify the default init(nibName:bundle:) method.
    
    override func viewDidLoad() {
      super.viewDidLoad()
      // Create a GMSCameraPosition that tells the map to display the
      // coordinate -33.86,151.20 at zoom level 6.
     
      mapView.isMyLocationEnabled = true
      view = mapView

      // Creates a marker in the center of the map.
      // Creates a marker in the center of the map.
      let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 39.0172657, longitude: -95.2640413)
      marker1.title = "Home"
      marker1.snippet = "HangZhou"
      marker1.map = mapView
        
      let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 38.9536, longitude: -94.7336)
      marker2.title = "High School"
      marker2.snippet = "Hangzhou"
      marker2.map = mapView
        getRouteSteps(from:marker1.position, to:marker2.position)
    
    }
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
