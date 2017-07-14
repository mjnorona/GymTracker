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
    var gym = [Gym]()
    
    var fulfilled = false
    
    //newStuff
    var dayArray = [String]()
    var newName = ""
    var newHour = 0
    var newMinute = 0
    var newLatitude = 0.0
    var newLongitude = 0.0
    var date: Date?
    var calendar: Calendar?
    var day: String?
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var location: CLLocation!
    override func viewDidLoad() {
        date = Date()
        calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        day = dateFormatter.string(from: date!)
        
        print("Today is: \(day!)")
        
        print(date!)
        print("DID LOAD")
        super.viewDidLoad()
        
        clearCoreData()
        print(name)
        print(days)
        print(time)
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
        
        
//        print("Dayz: \(dayArray)")
        print("hello")
        
        self.title = "Welcome, \(newName)!"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FormSegue" {
            let navigationController = segue.destination as! UINavigationController
            let formViewController = navigationController.topViewController as! FormViewController
            formViewController.delegate = self
        } else if segue.identifier == "TimerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let timerViewController = navigationController.topViewController as! TimerViewController
            timerViewController.delegate = self
            timerViewController.dataHour = newHour
            timerViewController.dataMinute = newMinute
        }
        
    }
    
    func getDay(){
        
    }
    
    
    
    func cancelButtonPressed(by controller: FormViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchAllItems() {
        print("hello")
        
        let requestName = NSFetchRequest<NSFetchRequestResult>(entityName: "Name")
        let requestDays = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        let requestTime = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        let requestGym = NSFetchRequest<NSFetchRequestResult>(entityName: "Gym")
        print("hello1")
        //delete requst
        
        do {
            print("hello2")
            let resultName = try context.fetch(requestName)
            
            name = resultName as! [Name]
//            for item in resultName {
//                context.delete(item as! NSManagedObject)
//            }
            
            
            print(name)
        } catch {
            print("\(error)")
        }
        
        do {
            let resultDays = try context.fetch(requestDays)
            days = resultDays as! [Days]
            
            print(days)
        } catch {
            print("\(error)")
        }
        
        do {
            let resultTime = try context.fetch(requestTime)
            time = resultTime as! [Time]
            
            print(time)
            
        } catch {
            print("\(error)")
        }
        
        do {
            let resultGym = try context.fetch(requestGym)
            gym = resultGym as! [Gym]
            
            print(time)
            
        } catch {
            print("\(error)")
        }
        print("hello3")
        
//        print(name[0].text!)
//        print(days[0].monday)
//        print(time[0].hours)
//        print(time[0].minutes)
        
        if days.count > 0 {
            let myDays = self.days[self.days.count - 1]
            print("hello!")
            //        print(myDays)
            
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
        }
        
        if time.count > 0 {
            let myTime = self.time[self.time.count - 1]
            newHour = Int(myTime.hours)
            newMinute = Int(myTime.minutes)
        }
        
        if gym.count > 0 {
            let myGym = self.gym[self.gym.count - 1]
            newLatitude = myGym.latitude
            newLongitude = myGym.longitude
        }
        
        if name.count > 0 {
            let myName = self.name[self.name.count - 1]
            newName = myName.text!
            print("Count name: \(myName.text)")
            print("New name: \(newName)")
        }
        
        self.title = "Welcome, \(newName)!"
        
        
    }
 
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationMananger.startUpdatingLocation()
        let
        latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        if latitude >= (newLatitude - 0.01) && latitude <= (newLatitude + 0.01) &&
            longitude >= (newLongitude - 0.01) && longitude <= (newLongitude + 0.01) {
            performSegue(withIdentifier: "TimerSegue", sender: sender)
        }
        
        print(latitude)
        print(longitude)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("DID APPEAR")
        super.viewDidAppear(animated)
//        fetchAllItems()
        
//        tableView.reloadData()
        
        
        
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
    
    func clearCoreData() {
        for item in name {
            context.delete(item)
        }
        
        for item in days {
            context.delete(item)
            
        }
        
        for item in time {
            context.delete(item)
            
        }
    }
    
    @IBAction func unwindForm(segue: UIStoryboardSegue) {
        print("HI!")
        dayArray = []
        let formViewController = segue.source as! FormViewController
        //data passed
        let tempName = formViewController.nameLabel.text
        print(1)
        let tempDays = formViewController.userDays
        print(2)
        var tempTime = [Int]()
        print(3)
        print(formViewController.userHours)
        tempTime.append(formViewController.userHours)
        print(4)
        tempTime.append(formViewController.userMinutes)
        print(5)
        var tempLatitude = formViewController.userLatitude
        print(6)
        var tempLongitude = formViewController.userLongitude
        print(7)
        
        print("over here")
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
        
        //gym data
        let userGym = NSEntityDescription.insertNewObject(forEntityName: "Gym", into: context) as! Gym
        userGym.setValue(tempLatitude, forKey: "latitude")
        userGym.setValue(tempLongitude, forKey: "longitude")
//        print("Latitude and Longitude")
//        print(userGym.latitude)
//        print(userGym.longitude)
        print("yo!")
        
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
        
        print("Here! \(dayArray)")
        fetchAllItems()
        print("Here also! \(dayArray)")
        
        
//        print(tempName!)
//        print(tempDays)
//        print(tempTime)
        
        
        
        print("unwinded")
        tableView.reloadData()
    }

    @IBAction func unwindTimer(segue: UIStoryboardSegue) {
        print("timed")
        let segue = (segue.source as! TimerViewController)
        fulfilled = segue.success
        print(fulfilled)
        let dayExists = false
        
    }
}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dayArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        cell.textLabel?.text = dayArray[indexPath.row]
        cell.tag = indexPath.row
        if cell.textLabel?.text == day && fulfilled == true {
            cell.backgroundColor = UIColor.green
        }
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


