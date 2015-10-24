//
//  CashViewController.swift
//  Cash Money
//
//  Created by Caevan Sachinwalla on 24/10/2015.
//  Copyright © 2015 AMKD Pty Ltd. All rights reserved.
//

import UIKit

class CashViewController: UIViewController {
    var currenncyRates:[String:NSNumber]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CurrencyRepository.getCurencyFromServerWithSuccess { (currencyData) -> Void in
            let json = JSON(data: currencyData)
            print("getCurencyFromServerWithSuccess: \(json)")
            if let ratesData = json["rates"].dictionary
            {
                print("viewdidLoad rates: \(ratesData)")
                var rates = [CashModel]()
                
                //3
                for rate in ratesData {
                    print("rate: \(rate) ")
                    let country:String? = rate.0
                    let countryRate:NSNumber? = rate.1.number
                    
                    let cashRate = CashModel(country: country, rate: countryRate)
                    rates.append(cashRate)
                    /*                    let appName: String? = appDict["im:name"]["label"].string
                    let appURL: String? = appDict["im:image"][0]["label"].string
                    
                    let app = AppModel(name: appName, appStoreURL: appURL)
                    apps.append(app) */
                }
                print(rates)
                let myRate = rates[0]
            print(myRate.country)
                //4
//                print(apps)
                
            }
            
            
            //            print("getCurencyFromServerWithSuccess rates: \(rates["USD"].string)")            CurrencyRepository.rates
            if let currencyValue = json["rates"]["USD"].number {
                print("NSURLSession: \(currencyValue)")
            }
        }
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
