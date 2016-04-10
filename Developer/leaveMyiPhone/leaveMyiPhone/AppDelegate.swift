//
//  AppDelegate.swift
//  leaveMyiPhone
//
//  Created by Iris Qin on 9/4/16.
//  Copyright © 2016年 Iris Qin. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        //开启后台处理多媒体事件
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setActive(true)
        }catch let error as NSError{
            print("Error:",error.localizedFailureReason)
        }

        //后台播放
        do{
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }catch let error as NSError{
                print("Error:",error.localizedFailureReason)
        }

        //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
       // _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
        //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}

