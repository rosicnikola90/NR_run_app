//
//  ViewController.swift
//  NR_run_app
//
//  Created by MacBook on 1/31/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@available(iOS 11.0, *)
class StartViewController: SharedVC  {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager?.startUpdatingLocation()
        centerMapOnUserLocation()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        //manager?.stopUpdatingLocation()
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
        }
    }
}

