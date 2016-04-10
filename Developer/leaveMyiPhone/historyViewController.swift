//
//  historyViewController.swift
//  leaveMyiPhone
//
//  Created by Iris Qin on 10/4/16.
//  Copyright © 2016年 Iris Qin. All rights reserved.
//

import UIKit

class historyViewController: UIViewController {

    @IBOutlet weak var badman: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL.fileURLWithPath(path2)
        let data = NSData.init(contentsOfURL: url)
        let image : UIImage = UIImage.init(data: data!, scale: 1)!

       badman.image = image
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
