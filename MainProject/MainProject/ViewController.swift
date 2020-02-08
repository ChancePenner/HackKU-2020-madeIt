//
//  ViewController.swift
//  MainProject
//
//  Created by Chance Penner on 2/8/20.
//  Copyright © 2020 Big-Segfault-Energy. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    // You don't need to modify the default init(nibName:bundle:) method.

    override func viewDidLoad() {
      super.viewDidLoad()
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
      let camera = GMSCameraPosition.camera(withLatitude: 30.173226, longitude: 120.269337, zoom: 16.0)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      mapView.isMyLocationEnabled = true
    view = mapView

    // Creates a marker in the center of the map.
    let marker1 = GMSMarker()
      marker1.position = CLLocationCoordinate2D(latitude: 30.173226, longitude: 120.269337)
    marker1.title = "Home"
    marker1.snippet = "HangZhou"
    marker1.map = mapView
      
    let marker2 = GMSMarker()
      marker2.position = CLLocationCoordinate2D(latitude: 30.188375, longitude: 120.263167)
    marker2.title = "High School"
    marker2.snippet = "Hangzhou"
    marker2.map = mapView
      
    }

    
}
