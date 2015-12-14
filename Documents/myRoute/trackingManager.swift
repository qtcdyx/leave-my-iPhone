//
//  trackingManager.swift
//  testmap
//
//  Created by Haoqian Zhang on 24/11/15.
//  Copyright © 2015 Haoqian Zhang. All rights reserved.
//

import Foundation
import CoreLocation

class trackingManager : NSObject, MAMapViewDelegate{

    var seenError : Bool = false
    var mode : Int = 0
    var intervalTimer : NSTimer = NSTimer()
    var intervalNum : Double = 1
    var mapView: MAMapView!
    var isRecording: Bool = false
    var currentRoute: Route?
    //接收login信息以上传
    var username :String = ""
    var token :String = ""
    

    func initTracking() {
        /*  manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization() */
        print("init")
        mapView = MAMapView()
        mapView.delegate = self
        mapView.showsUserLocation = false   //true时调用定位
        mapView.setUserTrackingMode(MAUserTrackingMode.None, animated: true)
        mapView.pausesLocationUpdatesAutomatically = false
        mapView.allowsBackgroundLocationUpdates = true
        //mapView.distanceFilter = 10.0
        mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
    }
    
    func anytimeMode()
    {
        mode=0
    }
    
    func significantMode()
    {
        mode=1
    }
    
    func intervalMode(intervalTime:Double)
    {
        intervalNum = intervalTime
        print(intervalNum)
        mode=2
    }
    
    func startTracking()
    {
        print("start")
        print(token)
         isRecording = true
        mapView.userTrackingMode = MAUserTrackingMode.Follow
        if currentRoute == nil {
            currentRoute = Route()
        }
        addLocation(mapView!.userLocation.location)
        if mode==0  // 随时定位
        {
            mapView.distanceFilter = -1
            //manager.stopMonitoringSignificantLocationChanges()
            //manager.startUpdatingLocation()
            stopIntervalTimer()
        }
        if mode==1  //移动时定位
        {
            mapView.distanceFilter = 10
            //manager.stopUpdatingLocation()
            //manager.startMonitoringSignificantLocationChanges()
            stopIntervalTimer()
        }
        if mode==2          //自定义时间间隔
        {
            mapView.distanceFilter = -1
            //manager.stopMonitoringSignificantLocationChanges()
            //manager.startUpdatingLocation()
            startIntervalTimer()
        }
    }
    
    //MARK:- Actions
    
    func stopLocationIfNeeded() {
        if !isRecording {
            print("stop location")
            mapView!.setUserTrackingMode(MAUserTrackingMode.None, animated: false)
            mapView!.showsUserLocation = false
        }
    }
    
    func stopTracking()
    {

        print("stop and Record")
        isRecording = false
        addLocation(mapView!.userLocation.location)
        Upload(username, token: token)          //先upload再save，暂定上传当前route
        saveRoute()
        mapView!.setUserTrackingMode(MAUserTrackingMode.None, animated: false)
        mapView!.showsUserLocation = false
        stopIntervalTimer()
        
    }
    
    //MARK:- Helpers
    
    func addLocation(location: CLLocation?) {
        
        if (currentRoute != nil){
            //print("add")
            let success = currentRoute!.addLocation(location)   // 已经注释掉失败情况：distance<filter 另外调试时最初无法实时更新
            if success {
                print("locations: \(currentRoute!.locations.count)")
            }
        }
        
    }
    
    func saveRoute() {
        
        if currentRoute == nil {
            return
        }
        
        let name = currentRoute!.title()
        
        let path = FileHelper.recordPathWithName(name)
        
        print("path: \(path)")
        
        NSKeyedArchiver.archiveRootObject(currentRoute!, toFile: path!)
        
        currentRoute = nil
    }
    
    //MARK:- MAMapViewDelegate
    
    func mapView(mapView: MAMapView , didUpdateUserLocation userLocation: MAUserLocation ) {
    
        if isRecording {
            
            // filter the result
            if userLocation.location.horizontalAccuracy < 80.0 {
                print("!!")
                addLocation(userLocation.location)
            }
        }
        if mode==2
        {
            mapView.setUserTrackingMode(MAUserTrackingMode.None, animated: true)  //坑爹啊！！！！这个函数只是设置定位小蓝点不会随着位置的变动移动
            mapView.showsUserLocation = false   //这个函才停止定位
            
        }

        
     /*   let location: CLLocation = userLocation.location
        
        var speed = location.speed
        if speed < 0.0 {
            speed = 0.0
        }
        
        let infoArray: [(String, String)] = [
            ("coordinate", NSString(format: "<%.4f, %.4f>", location.coordinate.latitude, location.coordinate.longitude) as String),
            ("speed", NSString(format: "%.2fm/s(%.2fkm/h)", speed, speed * 3.6) as String),
            ("accuracy", "\(location.horizontalAccuracy)m"),
            ("altitude", NSString(format: "%.2fm", location.altitude) as String)]
        
        statusView!.showStatusInfo(infoArray)*/
    }
    
    /**
     - (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated;
     */

    func Upload(username:String, token:String)->Int
    {
        let url:NSURL = NSURL(string: "http://114.215.120.46/upload")!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var Info : [[String: String]] = []
        for var pos=0 ; pos <  (currentRoute?.locations.count)!; pos++
        {
            let cllocation = currentRoute?.locations[pos]
            let longitude = NSString(format: "%f" , (cllocation?.coordinate.longitude)! )
            let latitude = NSString(format: "%f" , (cllocation?.coordinate.latitude)! )
            let speed = NSString(format: "%f" ,(cllocation?.speed)! * 1.609344)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let time = formatter.stringFromDate((cllocation?.timestamp)!)
            let infoUnit : [String:String] = ["longitude": longitude as String, "latitude":latitude as String, "speed": speed as String, "time":time]
            Info.append(infoUnit)
        }
        let json = [
            "username":username,
            "token":token,
            "locations":Info
        ]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(json,options:NSJSONWritingOptions.PrettyPrinted)  //打包json数据
           // let string = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding)
           //print(string)
        } catch let error as NSError {  //处理错误
            let e = NSError(domain: "JSONNeverDie.JSONParseError", code: error.code, userInfo: error.userInfo)
            print(e.localizedDescription)
        }
        
        let semaphore = dispatch_semaphore_create(0)
        var success : Int = 0
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("errorrrrrr")
                return
            }
            var json : AnyObject!
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)  //解析json数据
            } catch let error as NSError {
                let e = NSError(domain: "JSONNeverDie.JSONParseError", code: error.code, userInfo: error.userInfo)
                print(e.localizedDescription)
            }
            //解析获取JSON字段值
            let err = json.objectForKey("error")! as! Int
            if(err == 0){
                success = 1
                print("upload success")
            }
            else if (err == 1){
                print("token expired")
            }
            else if (err == 2){
                print("system error")
            }
            
            dispatch_semaphore_signal(semaphore)
        }
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return success;
    }

    
    func handleTimer(timer: NSTimer) {
       // manager.stopMonitoringSignificantLocationChanges()
       // manager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
    }
    
    func startIntervalTimer(){
        let doubleVar : Double = Double(intervalNum)
        let theTimeInterval : NSTimeInterval = doubleVar*60
        print(theTimeInterval)
        intervalTimer = NSTimer.scheduledTimerWithTimeInterval(theTimeInterval, target: self, selector: Selector("handleTimer:"), userInfo: nil, repeats: true)
    }
    
    func stopIntervalTimer(){
        intervalTimer.invalidate()
    }
}