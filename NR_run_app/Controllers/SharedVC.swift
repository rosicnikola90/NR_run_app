//
//  SharedVC.swift
//  NR_run_app
//
//  Created by MacBook on 2/28/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

@available(iOS 11.0, *)

class SharedVC: UIViewController, MKMapViewDelegate {
    
   static var manager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SharedVC.manager == nil {
            SharedVC.manager = CLLocationManager()
            SharedVC.manager?.desiredAccuracy = kCLLocationAccuracyBest
            SharedVC.manager?.activityType = .fitness
            SharedVC.manager?.allowsBackgroundLocationUpdates = true
            SharedVC.manager?.showsBackgroundLocationIndicator = true
        }
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            SharedVC.manager?.requestWhenInUseAuthorization()
        }
    }
    
    
}
