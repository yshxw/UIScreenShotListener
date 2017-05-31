//
//  UZModuleDemoSwift.swift
//  UZModule
//
//  Created by kenny on 15/1/14.
//  Copyright (c) 2015年 APICloud. All rights reserved.
//

import UIKit
import Foundation

@objc(UIScreenShotListener)
class UIScreenShotListener: UZModule {
    
    var _cbId : Int = 0
    
    var name:String = ""
    
    class func launch() {
        
    }
    
    override init!(uzWebView webView: Any!) {
        super.init(uzWebView: webView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BBScreenShot.postValue), name: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil)

    }
    
    override func dispose() {
        //do clean
    }

    //将值传给前端
    func postValue(n: Notification){
        
        guard name == "screenshot" else{
            return
        }

        let dic = NSMutableDictionary()
        
        do{
            let imageData = dataWithScreenshotInPNGFormat()
            let tmpDir:NSString = NSTemporaryDirectory() as NSString
            let imagePath = tmpDir.appendingPathComponent("screenshot.png")
            
            try imageData.write(to: URL(fileURLWithPath: imagePath))
            dic.setValue(true, forKey: "status")
            dic.setValue(imagePath, forKey: "imagePath")
            self.sendResultEvent(withCallbackId: _cbId, dataDict: dic as! [AnyHashable : Any], errDict: nil, doDelete: false)
            
        }catch{
            dic.setValue(false, forKey: "status")
            dic.setValue("保存图片到临时文件夹出错！", forKey: "msg")
            self.sendResultEvent(withCallbackId: _cbId, dataDict: nil, errDict: dic as! [AnyHashable : Any], doDelete: false)
        }
        
    }
    
    
    //打开（初始化数据）
    func addEventListener(_ paramDict:NSDictionary) {
        //接受前端传来的参数
        _cbId = paramDict.integerValue(forKey: "cbId", defaultValue: 0)
        name = paramDict.stringValue(forKey: "name", defaultValue: "screenshot")
    }

    
    /// 截取当前屏幕
    func dataWithScreenshotInPNGFormat() -> Data {
        var imageSize = CGSize.zero
        let screenSize = UIScreen.main.bounds.size
        let orientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsPortrait(orientation) {
            imageSize = screenSize
        } else {
            imageSize = CGSize(width: screenSize.height, height: screenSize.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        for window in UIApplication.shared.windows {
            context!.saveGState()
            context!.translateBy(x: window.center.x, y: window.center.y)
            context!.concatenate(window.transform)
            context!.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
            
            if orientation == UIInterfaceOrientation.landscapeLeft {
                context!.rotate(by: CGFloat(Double.pi/2))
                context!.translateBy(x: 0, y: -imageSize.width)
            } else if orientation == UIInterfaceOrientation.landscapeRight {
                context!.rotate(by: -CGFloat(Double.pi/2))
                context!.translateBy(x: -imageSize.height, y: 0)
            } else if (orientation == UIInterfaceOrientation.portraitUpsideDown) {
                context!.rotate(by: CGFloat(Double.pi))
                context!.translateBy(x: -imageSize.width, y: -imageSize.height)
            }
            if window.responds(to: #selector(UIView.drawHierarchy)){
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            } else {
                window.layer.render(in: context!)
            }
            context!.restoreGState();
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImagePNGRepresentation(image!)!
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
