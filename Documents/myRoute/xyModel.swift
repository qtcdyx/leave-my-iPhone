//
//  xyModel.swift
//  testmap
//
//  Created by Iris Qin on 7/12/15.
//  Copyright © 2015年 Haoqian Zhang. All rights reserved.
//

import Foundation
import MapKit
class xyModel: NSObject {
    var idx : Int = 0
    var startTime: String = ""
    //var xy: CLLocationCoordinate2D = CLLocationCoordinate2DMake(39.99452, 116.3099)
    var xys = [CLLocation]()  //存位置信息的数组
    
    
    override init() {
        //self.startTime = self.getStartTime()
    }
    
    func getStartTime() -> String{
        let nowDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.stringFromDate(nowDate)
        print("startTime:")
        print(dateString)
        return dateString
    }
    
}