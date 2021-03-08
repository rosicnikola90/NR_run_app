//
//  SharedVC.swift
//  NR_run_app
//
//  Created by MacBook on 2/28/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@available(iOS 11.0, *)
class SharedVC: UIViewController, MKMapViewDelegate {
    
    var manager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
        manager?.allowsBackgroundLocationUpdates = true
        manager?.showsBackgroundLocationIndicator = true
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager?.requestWhenInUseAuthorization()
        }
    }
    
    
}
