//
//  userManager.swift
//  testmap
//
//  Created by Haoqian Zhang on 25/11/15.
//  Copyright © 2015 Haoqian Zhang. All rights reserved.
//

import Foundation

class userManager : NSObject
{
    var  token : String = "" //定义token
    func register(username:String, var password:String)->Int
    {
        let url:NSURL = NSURL(string: "http://114.215.120.46/reg")!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") 
        password = password.md5 //md5加密
        let paramString : [String:String] = ["username": username, "password": password]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(paramString,options:NSJSONWritingOptions.PrettyPrinted)  //打包json数据
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
                print("error")
                return
            }
            var json : AnyObject!
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)  //解析json数据
            } catch let error as NSError {
                let e = NSError(domain: "JSONNeverDie.JSONParseError", code: error.code, userInfo: error.userInfo)
                print(e.localizedDescription)
            }
            dispatch_semaphore_signal(semaphore)
        //解析获取JSON字段值
        let err = json.objectForKey("error")! as! Int
        if(err == 0){
            success = 1
            print("succeed")
        }
        else if (err == 1){
            print("registered username")
        }
        else if (err == 2){
            print("system error")
        }
        
        let tokenn = json.objectForKey("token")! as! String
        //print(token)
        self.token = tokenn
        dispatch_semaphore_signal(semaphore)
    }
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return success;
    }
    
    func login(username:String, var password:String)->Int
    {
        let url:NSURL = NSURL(string: "http://114.215.120.46/login")!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")    //重要
        password = password.md5 //md5加密
        let paramString : [String:String] = ["username": username, "password": password]
        do {
             request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(paramString,options:NSJSONWritingOptions.PrettyPrinted)  //打包json数据
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
                print("error")
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
            }
            else if (err == 1){
                print("invalid username or password")
            }
            else if (err == 2){
                print("system error")
                }
            
            let tokenn = json.objectForKey("token")! as! String
            //print(token)
            self.token = tokenn
            dispatch_semaphore_signal(semaphore)
        }
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return success;
    }
}

//md5
extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestLen)
        return hash as String
        //return String(format: hash)
    }
}