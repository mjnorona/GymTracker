//
//  FormViewController.swift
//  
//
//  Created by MJ Norona on 7/13/17.
//
//

import UIKit
import GoogleMaps
import GooglePlaces

class FormViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {
    weak var delegate: ViewController?
    var userDays = ["Monday":false, "Tuesday":false, "Wednesday":false, "Thursday":false, "Friday":false, "Saturday":false, "Sunday":false]
    var userHours =  0
    var userMinutes = 0
    var userLatitude: Double?
    var userLongitude: Double?
    
    
    var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var times = [[0,1,2,3],[]]

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var googleMapContainer: GMSMapView!
    
    var locationManager = CLLocationManager()
    var autoCompleteController = GMSAutocompleteViewController()
   
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for i in 0..<60 {
            times[1].append(i)
        }
        self.hideKeyboardWhenTappedAround()
        
        //map
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .touchDown)
        
    }
    
    func textFieldDidChange(){
        print("touch location")
        //        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("click current location")
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12)
        self.googleMapContainer.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        marker.title = "Current location"
        marker.map = self.googleMapContainer
        
        
        
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMapContainer.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googleMapContainer.isMyLocationEnabled = true
        if(gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("resultQQQQQQQQ: ", place)
        userLatitude = place.coordinate.latitude
        userLongitude = place.coordinate.longitude
        locationTextField.text = place.formattedAddress
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 12.0)
        self.googleMapContainer.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.formattedAddress
        marker.map = self.googleMapContainer
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error AutoComplete: \(error)")
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FormViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath)
        cell.textLabel?.text = days[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            
            userDays[days[indexPath.row]] = false
            print(userDays)
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            userDays[days[indexPath.row]] = true
            print(userDays)
        }
    }
}

extension FormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times[component].count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(times[component][row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
            case 0:
                
                self.userHours = times[component][row]
                print(self.userHours)
            case 1:
                self.userMinutes = times[component][row]
                print(self.userMinutes)
            default: break
        }
    }
    
}
