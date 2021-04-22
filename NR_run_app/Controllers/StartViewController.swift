//
//  ViewController.swift
//  NR_run_app
//
//  Created by MacBook on 1/31/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

@available(iOS 11.0, *)
 class StartViewController: SharedVC  {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        print("VC lifecycle viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SharedVC.manager?.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        SharedVC.manager?.startUpdatingLocation()
        centerMapOnUserLocation()
        print("VC lifecycle viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VC lifecycle viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("VC lifecycle viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("VC lifecycle viewDidDisappear")
    }
    
    override func viewWillLayoutSubviews() {
        print("VC lifecycle viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        print("VC lifecycle viewDidLayoutSubviews")
    }
    
    @IBAction func goToPreviousRuns(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goDirectToRuns", sender: self)
    }
    

    @IBAction func startButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startCountToRun", sender: self)
    }
    
   
    
    func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    deinit {
        print("deinit StartVC")
    }
}

@available(iOS 11.0, *)

extension StartViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            errorLabel.isHidden = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            errorLabel.isHidden = false
            startButtonOutlet.isEnabled = false
        }
    }
}


