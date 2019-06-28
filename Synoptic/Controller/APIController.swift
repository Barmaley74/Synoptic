//
//  APIController.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 30.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation
import UIKit

protocol APIControllerProtocol {
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String)
}

class APIController {
    
    var delegate: APIControllerProtocol
    var resultKeys = [String:String]()

    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func get(_ path: String, _ key: String) {
        resultKeys[path] = key

        if Reachability.isConnectedToNetwork(){
            
            if let url = URL(string: path) {
                var request: URLRequest = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request, completionHandler: handlerGet)
                task.resume()
            }
        } else {
            Utils.displayAlertMessage(Messages.noInternet)
        }
        
    }
    
    func handlerGet (_ data: Data?, response: URLResponse?, error: Error?) {
        if let httpResponse = response as? HTTPURLResponse {
            let URL = httpResponse.url!.absoluteString as String
            if (httpResponse.statusCode == 404) {
                Utils.displayAlertMessage(Messages.pageNotFound)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            if (httpResponse.statusCode == 200 && data != nil) {
                let key = resultKeys[URL]
                do {
                    if URL.range(of: Config.apiIconURL) != nil {
                        self.delegate.didReceiveAPIResults(data! as AnyObject, URL: URL, key: key!)
                    } else {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        if jsonResult != nil {
                                let dict: NSDictionary = jsonResult! as NSDictionary
                                self.delegate.didReceiveAPIResults(dict, URL: URL, key: key!)
                        }
                    }
                } catch {
                    print(Messages.fetchFailed+"\((error as NSError).localizedDescription)")
                }
            } else {
                print(Messages.dataNil)
                self.delegate.didReceiveAPIResults(data! as AnyObject, URL: URL, key: "")
            }
        } else {
            Utils.displayAlertMessage(Messages.serverNotAvailable)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
    }
    
}

