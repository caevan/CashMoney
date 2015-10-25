//
//  CashModel.swift
//  Cash Money
//
//  Created by Caevan Sachinwalla on 24/10/2015.
//  Copyright © 2015 AMKD Pty Ltd. All rights reserved.
//

import UIKit
import Foundation

class CashModel: NSObject {
    
//    class AppModel: NSObject, CustomStringConvertible {
        let country: String
        let rate: NSNumber
        
        override var description: String {
//            return "Country: \(country), Rate: \(rate)\n"
            return " \(country), \(rate)\n"
        }
        
        init(country: String?, rate: NSNumber?) {
            self.country = country ?? ""
            self.rate = rate!
        }
}
