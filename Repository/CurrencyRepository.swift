//
//  CurrencyRepository.swift
//  Cash Money
//
//  Created by Caevan Sachinwalla on 24/10/2015.
//  Copyright © 2015 AMKD Pty Ltd. All rights reserved.
//

import UIKit
import Foundation

let currencyURL = "http://api.fixer.io/latest?base=AUD"

class CurrencyRepository: NSObject {
    var rates:[String:NSNumber]?
    class func getCurencyFromServerWithSuccess(success: ((currencyData: NSData!) -> Void)) {
        //1
        CurrencyRepository.loadDataFromURL(NSURL(string: currencyURL)!, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(currencyData: urlData)
            }
        })
    }
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.amkd", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    class func GetCurrencyData() -> Bool
    {
        CurrencyRepository.getCurencyFromServerWithSuccess { (currencyData) -> Void in
            let json = JSON(data: currencyData)
            print("getCurencyFromServerWithSuccess: \(json)")
            let ratesValues = json["rates"]
            print("getCurencyFromServerWithSuccess rates: \(ratesValues)")
//            print("getCurencyFromServerWithSuccess rates: \(rates["USD"].string)")            CurrencyRepository.rates
            if let currencyValue = json["rates"]["USD"].number {
                print("NSURLSession: \(currencyValue)")
            }
            // More soon...
        }
        return false
    }
}
