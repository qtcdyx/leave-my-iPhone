//
//  shapedButton.swift
//  testmap
//
//  Created by Iris Qin on 26/11/15.
//  Copyright © 2015年 Haoqian Zhang. All rights reserved.
//

import UIKit
import Foundation

class shapedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.setup()
        print("init")
    }
    func setup ()->Void{
        let _contentLayer = CALayer.init()
        let _maskLayer = CAShapeLayer.init(layer: _contentLayer)
        _maskLayer.path = UIBezierPath(ovalInRect: self.bounds).CGPath
        _maskLayer.fillColor = UIColor.blackColor().CGColor
        _maskLayer.strokeColor = UIColor.redColor().CGColor
        _maskLayer.frame = self.bounds
        _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1)
        _maskLayer.contentsScale = UIScreen.mainScreen().scale
        _contentLayer.mask = _maskLayer
        _contentLayer.frame = self.bounds
        _contentLayer.contents = UIImage.init(named: "dark.png")?.CGImage
        self.layer.addSublayer(_contentLayer)
        
        
      
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    /*override func setImage(image: UIImage?, forState state: UIControlState) {
        _contentLayer.contents = UIImage.init(named: "dark.png")?.CGImage
    }*/
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
