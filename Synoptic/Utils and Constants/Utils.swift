//
//  Utils.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 02/08/2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    
    static func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    static func displayAlertMessage(_ userMessage: String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        OperationQueue.main.addOperation {
            let topController = topViewController()
            topController!.present(myAlert, animated: true, completion: nil)
        }
    }
    
}
