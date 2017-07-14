//
//  ViewController.swift
//  GymTracker
//
//  Created by MJ Norona on 7/13/17.
//  Copyright © 2017 MJ Norona. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationMananger: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var name: String?
    var days = [String: Bool]()
    var time: [Int] = []
    

    var location: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        //current location manager
        locationMananger = CLLocationManager()
        locationMananger.delegate = self as CLLocationManagerDelegate
        locationMananger.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        //map
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "My Gym"
//        
//        marker.map = mapView
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideKeyboardWhenTappedAround() 
        
    }
 
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationMananger.startUpdatingLocation()
        let
        latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print(latitude)
        print(longitude)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func checkCoreLocationPermission() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationMananger.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .notDetermined {
            locationMananger.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .restricted {
            print("unauthorized to use location service")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        locationMananger.stopUpdatingLocation()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindForm(segue: UIStoryboardSegue) {
        
        
        
        
        print("unwinded")
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
