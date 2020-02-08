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
      
      
    let coordinate1 = "30.173226,120.269337"
    let coordinate2 = "30.188375,120.263167"
    let urlStr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(coordinate1)&destination=\(coordinate2)&key=AIzaSyCQJO6u77UF8FLdqBps0JzA0jjbBdkLuWI"
    
    guard let url = URL(string: urlStr) else {
      print("Error: cannot create URL")
      return
    }
    let urlRequest = URLRequest(url: url)
    // set up the session
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)

    // make the request
    let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
        
    enum JSONError: String, Error {
      case NoData = "ERROR: no data"
      case ConversionFailed = "ERROR: conversion from JSON failed"
    }
        
      do {
        guard let data = data else {
          throw JSONError.NoData
        }
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
          throw JSONError.ConversionFailed
        }
        print(json)
      } catch let error as JSONError {
        print(error.rawValue)
      } catch let error as NSError {
        print(error.debugDescription)
      }
        
    })
    let path = GMSPath(fromEncodedPath: "igdwDcfa}Uk@NiBX|@dDPjA@d@?dBAxAOh@}HJwJLuGF{LTwBF}CT{Kt@kEZaG^gCTiCPK`@AbBE~FClDY?")
    let polyline = GMSPolyline(path:path)
    polyline.strokeWidth = 4
    polyline.strokeColor = UIColor.init(hue: 210, saturation: 88, brightness: 84, alpha: 1)
    polyline.map = mapView
    task.resume()
    
  }

    
}
