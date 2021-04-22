//
//  RunDetailViewController.swift
//  NR_run_app
//
//  Created by MacBook on 3/6/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit
import MapKit
import CoreData

@available(iOS 11.0, *)
class RunDetailViewController: SharedVC {
    
    var runForDetal:Run?
    
    var avrPace:String?
    
    var locations = [Location]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var avrPaceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Run Details"
        mapView.isUserInteractionEnabled = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        if runForDetal != nil {
            getLocationsFromRun(run: runForDetal!)
            if locations.count != 0 {
                setupMapView()
                updateUIWith(run: runForDetal!)
            }
        }
        //print("detalji: \(String(describing: runForDetal?.locations))")
    }
    
     func updateUIWith ( run: Run) {
        timeLabel.text = run.duration
        distanceLabel.text = run.distance
        avrPaceLabel.text = run.avrPace
        dateLabel.text = run.date
    }
    
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor  = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        renderer.lineWidth = 4
        return renderer
        
    }
    
    func setupMapView() {
            let overlay = addLastRunToMap()
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
    }
    
    func addLastRunToMap() -> MKPolyline {
        
        var coordinate =  [CLLocationCoordinate2D]()
        for location in locations {
            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPrevRoute(locations:locations), animated: true)
        
        return MKPolyline(coordinates: coordinate, count: locations.count)
    }
    
    func centerMapOnPrevRoute(locations: [Location]) -> MKCoordinateRegion {
        let initialLoc =  locations[0]
        var minLat = initialLoc.latitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng =  minLng
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.longitude)
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLng + maxLng)/2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.4, longitudeDelta: (maxLng - minLng)*1.4))
    }
    
     func getLocationsFromRun (run:Run) {
        if run.locations != nil {
        for (index, _ ) in run.locations!.enumerated() {
            if (index == 0 || index % 2 == 0) {
                let newLocation = Location(latitude: run.locations![index], longitude: run.locations![index+1])
                locations.append(newLocation)
                }
            }
           // print(locations)
        }
    }
    
   
    deinit {
        print("deinit RunDetailViewController")
    }
}
