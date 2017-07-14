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
import CoreData


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationMananger: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var name = [Name]()
    var days = [Days]()
    var time = [Time]()
    var dayArray = [String]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var location: CLLocation!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        fetchAllItems()
//        print("Name: \(name)")
//        print("Days: \(days)")
        
        let myDays = self.days[0]
        print(myDays)
        
        if myDays.monday {
            dayArray.append("Monday")
        }
        if myDays.tuesday {
            dayArray.append("Tuesday")
        }
        if myDays.wednesday {
            dayArray.append("Wednesday")
        }
        if myDays.thursday {
            dayArray.append("Thursday")
        }
        if myDays.friday {
            dayArray.append("Friday")
        }
        if myDays.saturday {
            dayArray.append("Saturday")
        }
        if myDays.sunday {
            dayArray.append("Sunday")
        }
        print("Dayz: \(dayArray)")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let formViewController = navigationController.topViewController as! FormViewController
        formViewController.delegate = self
    }
    
    func cancelButtonPressed(by controller: FormViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchAllItems() {
        let requestName = NSFetchRequest<NSFetchRequestResult>(entityName: "Name")
        let requestDays = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        let requestTime = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        
        do {
            let resultName = try context.fetch(requestName)
            name = resultName as! [Name]
//            print(name)
        } catch {
            print("\(error)")
        }
        
        do {
            let resultDays = try context.fetch(requestDays)
            days = resultDays as! [Days]
//            print(days)
        } catch {
            print("\(error)")
        }
        
        do {
            let resultTime = try context.fetch(requestTime)
            time = resultTime as! [Time]
//            print(time)
        } catch {
            print("\(error)")
        }
        print(name[0].text!)
        print(days[0].monday)
        print(time[0].hours)
        print(time[0].minutes)
        
        
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
        let formViewController = segue.source as! FormViewController
        //data passed
        let tempName = formViewController.nameLabel.text
        let tempDays = formViewController.userDays
        var tempTime = [Int]()
        tempTime.append(formViewController.userHours!)
        tempTime.append(formViewController.userHours!)
        
        //core data***
        
        //name data
        let userName = NSEntityDescription.insertNewObject(forEntityName: "Name", into: context) as! Name
        
        userName.setValue(tempName, forKey: "text")
        
        //days data
        let userDays = NSEntityDescription.insertNewObject(forEntityName: "Days", into: context) as! Days
        userDays.setValue(tempDays["Monday"], forKey: "monday")
        userDays.setValue(tempDays["Tuesday"], forKey: "tuesday")
        userDays.setValue(tempDays["Wednesday"], forKey: "wednesday")
        userDays.setValue(tempDays["Thursday"], forKey: "thursday")
        userDays.setValue(tempDays["Friday"], forKey: "friday")
        userDays.setValue(tempDays["Saturday"], forKey: "saturday")
        userDays.setValue(tempDays["Sunday"], forKey: "sunday")
        
        //time data
        let userTime = NSEntityDescription.insertNewObject(forEntityName: "Time", into: context) as! Time
        
        userTime.setValue(tempTime[0], forKey: "hours")
        userTime.setValue(tempTime[1], forKey: "minutes")
        
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
        
       
        
        print(tempName!)
        print(tempDays)
        print(tempTime)
        
        
        
        print("unwinded")
    }


}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dayArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        cell.textLabel?.text = dayArray[indexPath.row]
        return cell
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


