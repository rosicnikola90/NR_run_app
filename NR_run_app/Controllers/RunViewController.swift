//
//  RunViewController.swift
//  NR_run_app
//
//  Created by MacBook on 1/31/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit
import MapKit
import CoreData

@available(iOS 11.0, *)

 class RunViewController: SharedVC {
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var resumetButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var distanceRunLabel: UILabel!
    
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var startLocation : CLLocation?
    var lastLocation : CLLocation?
    var timer:Timer = Timer()
    var coordinateLocations = Array<Double>()
    var runDistance = 0.0
    var timerCount = 0
    var pace = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SharedVC.manager?.delegate = self
        SharedVC.manager?.distanceFilter = 10
        startRun()
        
    }
    
    func startRun() {
        SharedVC.manager?.startUpdatingLocation()
        startTimer()
        pauseButton.isHidden = false
        startButton.isHidden = true
        resumetButton.isHidden = true
    }
    
    func endRun() {
        SharedVC.manager?.stopUpdatingLocation()
        SharedVC.manager?.allowsBackgroundLocationUpdates = false
        SharedVC.manager?.showsBackgroundLocationIndicator = false
        // save RUN
    }
    
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        SharedVC.manager?.stopUpdatingLocation()
        pauseButton.isHidden = true
        resumetButton.isHidden = false
        startButton.isHidden = false
    }
    @IBAction func pausePlayPressed(_ sender: UIButton) {
        if timer.isValid {
            pauseRun()
        }
    }
    
    
    @IBAction func resumePressed(_ sender: UIButton) {
        startRun()
    }
    
    
    @IBAction func stopButton(_ sender: UIButton) {
        endRun()
        saveRun()
        performSegue(withIdentifier: "runs", sender: self)
    }
    
    func startTimer() {
        timerLabel.text = formatTimeToString(time: timerCount)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        timerCount += 1
        timerLabel.text = formatTimeToString(time: timerCount)
    }
    
    func calculatePace(time seconds: Int, km: Double) -> String{
        if km == 0 {
            return "no value"
        }
        else {
        pace = Int((Double(seconds) / km))
        return formatTimeToString(time: pace)
        }
    }
    
    func formatTimeToString(time:Int) -> String {
        
        let durationHours = time / 3600
        let durationMinutes = (time % 3600) / 60
        let durationSeconds = (time % 3600) % 60
        
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes, durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
                }
            }
        }
    
    func roundMeters(value:Double , places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (((value/1000) * divisor).rounded() / divisor ) 
    }
    
    func saveRun () {
        let newRun = Run (context:context)
        newRun.date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        newRun.distance = String(roundMeters(value:runDistance, places: 2))
        newRun.duration = formatTimeToString(time: timerCount)
        newRun.locations = coordinateLocations
        newRun.avrPace = calculatePace(time: timerCount, km: roundMeters(value: runDistance, places: 2))
       // print("SAVED RUN : \(String(describing: newRun.locations))")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    deinit {
        print("deinit RunViewController")
    }
}



@available(iOS 11.0, *)
extension RunViewController : CLLocationManagerDelegate {
    
   // provera statusa
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startRun()
        }
        else if status == .denied {
            pauseRun()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation!.distance(from: location)
            
            coordinateLocations.append(Double(lastLocation!.coordinate.latitude))
            coordinateLocations.append(Double(lastLocation!.coordinate.longitude))

            distanceRunLabel.text = String(roundMeters(value:runDistance, places: 2)) 
            if timerCount > 0 && runDistance > 0 {
                paceLabel.text = calculatePace(time: timerCount, km: roundMeters(value: runDistance, places: 2))
            }
        }
        lastLocation = locations.last
    }
}
