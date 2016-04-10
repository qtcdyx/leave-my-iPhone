//
//  ViewController.swift
//  leaveMyiPhone
//
//  Created by Iris Qin on 9/4/16.
//  Copyright © 2016年 Iris Qin. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
 import LocalAuthentication


class ViewController: UIViewController,UIAccelerometerDelegate {

      var manager: CMMotionManager = CMMotionManager()
    var isPlaying:Bool = false
    var neverplay:Bool = false
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func STOP(sender: AnyObject) {
        touchID()
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        neverplay = false
        if manager.accelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.01
            let queue = NSOperationQueue.currentQueue()
            manager.startAccelerometerUpdatesToQueue(queue!, withHandler:
                { (accelerometerData : CMAccelerometerData?, error: NSError?) -> Void in
                        self.doAcceleration((accelerometerData?.acceleration)!)
            })
        
        }
        // Do any additional setup after loading the view, typically from a nib.
        let path = NSBundle.mainBundle().URLForResource("Future Islands - Tin Man", withExtension: "mp3")
        //        var error:NSError?
        do{
            let para = try AVAudioPlayer(contentsOfURL: path!)
            audioPlayer=para
            audioPlayer.numberOfLoops = -1
        }catch let error as NSError{
            print("Error:",error.localizedFailureReason)
        }
    }
    func touchID(){
        //1.初始化TouchID句柄
        let authentication = LAContext()
        var error: NSError?
        
        //2.检查Touch ID是否可用
        let isAvailable = authentication.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics,
            error: &error)
        
        //3.处理结果
        if isAvailable
        {
            NSLog("Touch ID is available")
            //这里是采用认证策略 LAPolicy.DeviceOwnerAuthenticationWithBiometrics
            //--> 指纹生物识别方式
            authentication.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "这里需要您的指纹来进行识别验证", reply: {
                //当调用authentication.evaluatePolicy方法后，系统会弹提示框提示用户授权
                (success, error) -> Void in
                if success
                {
                    NSLog("您通过了Touch ID指纹验证！")
                    self.audioPlayer.stop()
                    self.audioPlayer.currentTime = 0
                    self.isPlaying = false
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.neverplay = true
                }
                else
                {
                    //上面提到的指纹识别错误
                    NSLog("您未能通过Touch ID指纹验证！错误原因：\n\(error)")
                }
            })
        }
        else
        {
            //上面提到的硬件配置
            NSLog("Touch ID不能使用！错误原因：\n\(error)")
        }

    
    }
    func doAcceleration(acceleration: CMAcceleration) {
        if(!neverplay){
            if (acceleration.z < -1.3) {
                print("move!")
                audioPlayer.play()
                isPlaying = true
                touchID()
            }
        }
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

