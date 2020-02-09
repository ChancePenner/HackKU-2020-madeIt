//
//  MainMenu.swift
//  MainProject
//
//  Created by Markus Becerra on 2/8/20.
//  Copyright © 2020 Big-Segfault-Energy. All rights reserved.
//

import UIKit
import GoogleMaps
import Foundation
import Alamofire

var userName = "Markus"
class MainMenu: UIViewController {
   
    
    @IBAction func buttonClicked(_ sender: Any) {
//              let functionURL = "https://honeydew-serval-3887.twil.io/epic"
//              if let url = URL(string: functionURL) {
//                  let task = URLSession.shared.dataTask(with: url) {
//                      data, response, error in
//                      if error != nil {
//                          print(error!)
//                      }
//                  }
//                  task.resume()
              if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
                 let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"] {
               let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
                let parameters = ["From": "+18065471980", "To": "9133134958", "Body": "\(userName) made it home!!!"]
      
                Alamofire.request(url, method: .post, parameters: parameters)
                  .authenticate(user: accountSID, password: authToken)
                  .responseJSON { response in
                    debugPrint(response)
                    
                    print("peepee")
                }

              }
    print("I DIDNT DO ANYTHING")
          
    }
          
          override func viewDidLoad() {
              super.viewDidLoad()
          }
      //    override func loadView() {
      //      // Create a GMSCameraPosition that tells the map to display the
      //      // coordinate -33.86,151.20 at zoom level 6.
      //      let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
      //      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      //      view = mapView
      //
      //      // Creates a marker in the center of the map.
      //      let marker = GMSMarker()
      //      marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
      //      marker.title = "Sydney"
      //      marker.snippet = "Australia"
      //      marker.map = mapView
      //    }


}

