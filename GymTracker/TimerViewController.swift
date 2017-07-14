//
//  TimerViewController.swift
//  GymTracker
//
//  Created by MJ Norona on 7/14/17.
//  Copyright © 2017 MJ Norona. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    weak var delegate: ViewController?
    var dataHour: Int?
    var dataMinute: Int?
    var min = 0
    var minCounter = 0
    var hour = 0
    var timer = Timer()
    var success = false
    @IBOutlet weak var hourlabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    
    
    
    
    
    func counter() {
        min+=1
        minCounter += 1
        
        
        //where to stop the timer
        
        
        if min % 60 == 0 {
            hour+=1
            minCounter = 0
        }
        
        
        print(minCounter)
        hourlabel.text = ("\(String(hour)) hours")
        minuteLabel.text = ("\(String(minCounter)) minutes")
        
        if minCounter == dataMinute! && hour == dataHour! {
            print("something")
            stopTimer()
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        
        
        let alert = UIAlertController(title: "Success", message: "You completed your daily goal!", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OkAction)
        self.present(alert, animated: true, completion: nil)
        
        success = true
        
        
        print("the total time at the gym is: \(String(hour)) hour and \(String(minCounter))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        minuteLabel.text = ("\(String(min)) minutes")
        hourlabel.text = ("\(String(hour)) hours")
        print(dataMinute!)
        print(dataHour!)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {_ in
            self.counter()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
