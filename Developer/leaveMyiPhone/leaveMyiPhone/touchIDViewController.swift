//
//  touchIDViewController.swift
//  leaveMyiPhone
//
//  Created by Iris Qin on 9/4/16.
//  Copyright © 2016年 Iris Qin. All rights reserved.
//

import UIKit
 import LocalAuthentication

class touchIDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
