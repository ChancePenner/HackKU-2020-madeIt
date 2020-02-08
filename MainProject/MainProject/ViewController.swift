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

class ViewController: UIViewController {

    
    var street_number: String = ""
    var route: String = ""
    var neighborhood: String =  ""
    var locality: String = ""
    var country: String = ""
    var postal_code: String = ""
    var postal_code_suffix: String = ""
    

    override func loadView() {
      // Create a GMSCameraPosition that tells the map to display the
      // coordinate -33.86,151.20 at zoom level 6.
      let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      view = mapView

      // Creates a marker in the center of the map.
//      let marker = GMSMarker()
//      marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//      marker.title = "Sydney"
//      marker.snippet = "Australia"
//      marker.map = mapView
        
      let position = CLLocationCoordinate2D(latitude: 10, longitude: 10)
      let marker = GMSMarker(position: position)
      marker.title = "Your Destination"
      marker.map = mapView
   // marker.appearAnimation =
    }
    
     override func viewDidLoad() {
        makeButton()
      }

      // Present the Autocomplete view controller when the button is pressed.
      @objc func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self


        // Specify a filter.
        let addressFilter = GMSAutocompleteFilter()
        addressFilter.type = .address
        autocompleteController.autocompleteFilter = addressFilter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
      }

      // Add a button to the view.
      func makeButton() {
        let btnLaunchAc = UIButton(frame: CGRect(x: 10, y: 80, width: 300, height: 35))
        btnLaunchAc.backgroundColor = .gray
        btnLaunchAc.setTitle("Choose destination", for: .normal)
        btnLaunchAc.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
        self.view.addSubview(btnLaunchAc)
      }
    func printStuff() {
        print(street_number)
        print(route)
        print(neighborhood)
        print(locality)
        print(country)
        print(postal_code)
        print(postal_code_suffix)
        
        street_number = ""
        route = ""
        neighborhood = ""
        locality = ""
        country = ""
        postal_code = ""
        postal_code_suffix = ""
        
    }
    }
extension ViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    // Print place info to the console
    print("Place name: \(place.name ?? "")")
    print("Place address: \(place.formattedAddress ?? "")")
    print("Place attributions: \(String(describing: place.attributions))")
    print("Place Latitude: \(place.coordinate.latitude)")
    print("Place Longitude: \(place.coordinate.longitude)")

    // Get the address components.
    if let addressLines = place.addressComponents {
      // Populate all of the address fields we can find.
      for field in addressLines {
        //field was field.stype before
        switch field.type{
        case kGMSPlaceTypeStreetNumber:
          street_number = field.name
        case kGMSPlaceTypeRoute:
          route = field.name
        case kGMSPlaceTypeNeighborhood:
          neighborhood = field.name
        case kGMSPlaceTypeLocality:
          locality = field.name
        case kGMSPlaceTypeCountry:
          country = field.name
        case kGMSPlaceTypePostalCode:
          postal_code = field.name
        case kGMSPlaceTypePostalCodeSuffix:
          postal_code_suffix = field.name
        // Print the items we aren't using.
        default:
            print("Type: \(field.type), Name: \(field.name)")
        }
      }
    }

    // Call custom function to populate the address form.
    printStuff()

    // Close the autocomplete widget.
    self.dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Show the network activity indicator.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  // Hide the network activity indicator.
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
}
    
