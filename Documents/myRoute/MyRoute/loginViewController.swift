//
//  loginViewController.swift
//  testmap
//
//  Created by Iris Qin on 25/11/15.
//  Copyright © 2015年 Haoqian Zhang. All rights reserved.
//

import UIKit
import QuartzCore

class loginViewController: UIViewController {

    
    @IBOutlet weak var usernameField:   UITextField!
    @IBOutlet weak var imageView:       UIImageView!
    @IBOutlet weak var passwordField:   UITextField!
    @IBOutlet weak var loginButton:     UIButton!
    
    var user = userManager()
    var alertView:UIAlertView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 81.0/255.0, blue: 94.0/255.0, alpha: 0.5), NSFontAttributeName: UIFont(name: "Chalkduster", size: 24.0)!]
        
        loginButton.layer.cornerRadius = 16.5
        usernameField.alpha = 0;
        passwordField.alpha = 0;
        loginButton.alpha   = 0;
        
        //控件的渐入效果
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.usernameField.alpha = 1.0
            self.passwordField.alpha = 1.0
            self.loginButton.alpha   = 0.9
            }, completion: nil)
        
        //添加屏幕点击事件
        imageView.userInteractionEnabled = true
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        imageView .addGestureRecognizer(singleTap)
        
        //监控textFields的变化
        usernameField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        passwordField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        
        
        //背景模糊特效
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark)) as UIVisualEffectView
        visualEffectView.frame = self.view.frame
        visualEffectView.alpha = 0.5
        imageView.image = UIImage(named: "img1.jpg")
        imageView.addSubview(visualEffectView)
    
        self.loginButton(false)
        
    }
    
    func loginButton(enabled: Bool) -> () {
        func enable(){
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.loginButton.backgroundColor = UIColor.colorWithHex("#33CC00", alpha: 1)
                }, completion: nil)
            loginButton.enabled = true
        }
        func disable(){
            loginButton.enabled = false
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.loginButton.backgroundColor = UIColor.colorWithHex("#333333",alpha :1)
                }, completion: nil)
        }
        return enabled ? enable() : disable()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func textFieldDidChange() {
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty
        {
            self.loginButton(false)
        }
        else
        {
            self.loginButton(true)
        }
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        if(user.login(usernameField.text!, password: passwordField.text! ) == 1){
            succeedUIAlertView()
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            failUIAlertView()
        }
        
    }
    func succeedUIAlertView(){
        
        alertView = UIAlertView()
        alertView!.message = "Succeed!"
        NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector:"dismiss:", userInfo:alertView!, repeats:false)
        alertView!.show()
        
    }
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }
    func failUIAlertView(){
        
        alertView = UIAlertView()
        alertView!.title = "Notice"
        alertView!.message = "Invalid username or wrong password!"
        alertView!.addButtonWithTitle("Try again")
        //NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector:"dismiss:", userInfo:alertView!, repeats:false)
        alertView!.show()
        
    }

    
    @IBAction func signupPressed(sender: AnyObject) {
    }
    
    func imageViewTouch(){    //点击屏幕输入法消失
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
    }
    
}

//Extension for Color to take Hex Values
extension UIColor{
    
    class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var rgb: CUnsignedInt = 0;
        let scanner = NSScanner(string: hex)
        
        if hex.hasPrefix("#") {
            // skip '#' character
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }

}
