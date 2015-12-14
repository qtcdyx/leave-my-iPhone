//
//  ViewController.swift
//  testmap
//
//  Created by Haoqian Zhang on 21/11/15.
//  Copyright © 2015 Haoqian Zhang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var theLabel: UILabel!
    var manager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0) //设置navigation bar背景色
        //Marion-Italic
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 81.0/255.0, blue: 94.0/255.0, alpha: 0.5), NSFontAttributeName: UIFont(name: "Chalkduster", size: 24.0)!] //设置title
        
        
        theMap.delegate = self
        theMap.mapType = MKMapType.Standard
        theMap.showsUserLocation = true
        

        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let spanX = 0.01
        let spanY = 0.01
        let newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap.setRegion(newRegion, animated: true)
    }
    
}
}
