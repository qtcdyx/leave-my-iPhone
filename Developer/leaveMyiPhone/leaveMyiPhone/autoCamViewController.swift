//
//  autoCamViewController.swift
//  leaveMyiPhone
//
//  Created by Iris Qin on 9/4/16.
//  Copyright © 2016年 Iris Qin. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
//import Alamofire
import MobileCoreServices

var path2 : String!


class autoCamViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {

    var callBack :((face: UIImage) ->())?
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var pickUIImager : UIImageView = UIImageView(image: UIImage(named: "pick_bg"))
    var line : UIImageView = UIImageView(image: UIImage(named: "line"))
    var timer : NSTimer!
    var upOrdown = true
    var isStart = false
    var samePerson : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //找设备，找到摄像头后，开启摄像头
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Front) {
                    captureDevice = device as?AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture Device found")
                        beginSession()
                    }
                }
            }
        }
        pickUIImager.frame = CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2 - 100,width: 200,height: 200)
        line.frame = CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2 - 100, width: 200, height: 2)
        self.view.addSubview(pickUIImager)
        self.view.addSubview(line)
        timer =  NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "animationSate", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
        //0.5s延迟
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "isStartTrue", userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func isStartTrue(){
        self.isStart = true
    }
    
    //动态显示扫描线的方法
    func animationSate(){
        if upOrdown {
            if (line.frame.origin.y >= pickUIImager.frame.origin.y + 200)
            {
                upOrdown = false
            }
            else
            {
                line.frame.origin.y += 2
            }
        } else {
            if (line.frame.origin.y <= pickUIImager.frame.origin.y)
            {
                upOrdown = true
            }
            else
            {
                line.frame.origin.y -= 2
            }
        }
    }
    
    
    
    
//开启摄像头
    func beginSession() {
        do{
            let a = try AVCaptureDeviceInput.init(device: captureDevice)
            captureSession.addInput(a)
        }catch let error as NSError{
            print("Error:",error.localizedFailureReason)
        }
        
        let output = AVCaptureVideoDataOutput()
        let cameraQueue = dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL)
        output.setSampleBufferDelegate(self, queue: cameraQueue)
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey : Int(kCVPixelFormatType_32BGRA)]
        captureSession.addOutput(output)
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = "AVLayerVideoGravityResizeAspect"
        previewLayer?.frame = self.view.bounds
        //self.view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
//实现captureOutput 方法
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        if(self.isStart)
        {
            let resultImage = sampleBufferToImage(sampleBuffer)
            
            let context = CIContext(options:[kCIContextUseSoftwareRenderer:true])
            let detecotr = CIDetector(ofType:CIDetectorTypeFace,  context:context, options:[CIDetectorAccuracy: CIDetectorAccuracyHigh])
            
            let ciImage = CIImage(image: resultImage)
            
            let results:NSArray = detecotr.featuresInImage(ciImage!,options: ["CIDetectorImageOrientation" : 6])
            
            for r in results {
                let face:CIFaceFeature = r as! CIFaceFeature;
                let faceImage = UIImage(CGImage: context.createCGImage(ciImage!, fromRect: face.bounds),scale: 1.0, orientation: .Right)
                
                NSLog("Face found at (%f,%f) of dimensions %fx%f", face.bounds.origin.x, face.bounds.origin.y,pickUIImager.frame.origin.x, pickUIImager.frame.origin.y)
                
                dispatch_async(dispatch_get_main_queue()) {
                    if (self.isStart)
                    {
                        //self.dismissViewControllerAnimated(true, completion: nil)
                        self.didReceiveMemoryWarning()
                        let library = ALAssetsLibrary.init()
                        let orientation : ALAssetOrientation = ALAssetOrientation(rawValue: faceImage.imageOrientation.rawValue)!
                        library.writeImageToSavedPhotosAlbum(faceImage.CGImage, orientation: orientation, completionBlock: { (path:NSURL!, error:NSError!) -> Void in
                            print("\(path)")
                            path2 = path.absoluteString
                        })
                        //self.callBack!(face: faceImage)
                    }
                    self.isStart = false
                }
            }
        }
    }
    private func sampleBufferToImage(sampleBuffer: CMSampleBuffer!) -> UIImage {
        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        let baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)
        
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        
        let bitsPerCompornent = 8
        var bitmapInfo =  CGBitmapInfo.init(rawValue: (CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue) as UInt32)
       
        
        let newContext = CGBitmapContextCreate(baseAddress, width, height, bitsPerCompornent, bytesPerRow, colorSpace, (CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue) as UInt32)! as CGContextRef
        
        let imageRef: CGImageRef = CGBitmapContextCreateImage(newContext)!
        let resultImage = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Right)
        
        return resultImage
    }
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        captureSession.stopRunning()
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
