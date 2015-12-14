//
//  loginViewController.swift
//  testmap
//
//  Created by Iris Qin on 25/11/15.
//  Copyright © 2015年 Haoqian Zhang. All rights reserved.
//

import UIKit
import QuartzCore

class signupViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField:   UITextField!
    @IBOutlet weak var imageView:       UIImageView!
    @IBOutlet weak var passwordField:   UITextField!
    @IBOutlet weak var loginButton:     UIButton!
    
    var user = userManager()
    var alertView:UIAlertView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0) //设置navigation bar背景色
        //Marion-Italic
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 81.0/255.0, blue: 94.0/255.0, alpha: 0.5), NSFontAttributeName: UIFont(name: "Chalkduster", size: 24.0)!] //设置title
        loginButton.layer.cornerRadius = 16.5
        usernameField.alpha = 0;
        passwordField.alpha = 0;
        loginButton.alpha   = 0;
        
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.usernameField.alpha = 1.0
            self.passwordField.alpha = 1.0
            self.loginButton.alpha   = 0.9
            }, completion: nil)
        
        // Notifiying for Changes in the textFields
        usernameField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        passwordField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        
        
        // Visual Effect View for background
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark)) as UIVisualEffectView
        visualEffectView.frame = self.view.frame
        visualEffectView.alpha = 0.5
        imageView.image = UIImage(named: "img2.jpg")
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
        if(user.register(usernameField.text!, password: passwordField.text! ) == 1){
            succeedUIAlertView()
            self.navigationController?.popToRootViewControllerAnimated(true)
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
        alertView!.message = "registered username!"
        alertView!.addButtonWithTitle("Try again")
        //NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector:"dismiss:", userInfo:alertView!, repeats:false)
        alertView!.show()
        
    }
    
    
    
    @IBAction func backgroundPressed(sender: AnyObject) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
    }
}


