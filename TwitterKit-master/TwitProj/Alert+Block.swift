//
//  Alert+Block.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import Foundation
import UIKit


enum AlertAction{
    case Ok
    case Cancel
}

typealias AlertCompletionHandler = ((_ index:AlertAction)->())?
typealias AlertCompletionHandlerInt = ((_ index:Int)->())

class Alert:UIViewController{
    

static let topVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController

    
   class func showAlert(title:String?, message:String?){
    
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:.default, handler:nil))
    topVC?.present(alert, animated: true)
    }
    
    class func showAlertWithHandler(title:String?, message:String?, handler:AlertCompletionHandler){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:"Ok", style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style:.default, handler: { (alert) in
            handler?(AlertAction.Cancel)
        }))
        topVC?.present(alert, animated: true)
    }
    
    class func showAlertWithHandler(title:String?, message:String?, okButtonTitle:String, handler:AlertCompletionHandler){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:okButtonTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        topVC?.present(alert, animated: true)
    }
    
    class func showAlertWithHandler(title:String?, message:String?, okButtonTitle:String, cancelButtionTitle:String,handler:AlertCompletionHandler){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:okButtonTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        alert.addAction(UIAlertAction(title:cancelButtionTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Cancel)
        }))
        
        topVC?.present(alert, animated: true)
    }
    
    
    class func showAlertWithHandler(title:String?, message:String?, buttonsTitles:[String], showAsActionSheet: Bool,handler:@escaping AlertCompletionHandlerInt){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: (showAsActionSheet ?.actionSheet : .alert))
        
        for btnTitle in buttonsTitles{
            alert.addAction(UIAlertAction(title:btnTitle, style:.default, handler: { (alert) in
                handler(buttonsTitles.index(of: btnTitle)!)
            }))
        }
        
        topVC?.present(alert, animated: true)
    }
}

