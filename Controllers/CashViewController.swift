//
//  CashViewController.swift
//  Cash Money
//
//  Created by Caevan Sachinwalla on 24/10/2015.
//  Copyright © 2015 AMKD Pty Ltd. All rights reserved.
//

import UIKit
private let cueeencyCellReuseIdentifier = "CurrencyCollectionViewCell"
private let chooseCurrency: [String] = ["CAD", "EUR", "GBP", "JPY", "USD"]

class CashViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    
    @IBOutlet weak var txtFromCurrency: UITextField!
    
    
    @IBOutlet weak var txtToCurrency: UILabel!
    var currenncyRates:[String:NSNumber]?
    var currentCurrencyIndex:Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currencyCollectionView.dataSource = self;
        currencyCollectionView.delegate = self;
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
//                self.setupCollectionView()
                self.currencyCollectionView.reloadData()
                
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
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return chooseCurrency.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cueeencyCellReuseIdentifier, forIndexPath: indexPath) as! CurrencyCollectionViewCell
        cell.lblCurrency.text = chooseCurrency[indexPath.row]
        if(indexPath.row == currentCurrencyIndex){
            cell.lblCurrency.textColor = UIColor.whiteColor()
        }
        return cell
    }
    func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 2.0
        self.currencyCollectionView.pagingEnabled = false
        self.currencyCollectionView.collectionViewLayout = flowLayout
    }
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        currentCurrencyIndex = indexPath.row;
        let newIndex = NSIndexPath(forRow: currentCurrencyIndex, inSection: 0)
        self.currencyCollectionView.scrollToItemAtIndexPath(newIndex, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        //            let newIndex = NSIndexPath(forRow: currentImageIndex, inSection: 0)
        self.currencyCollectionView.layoutIfNeeded()
        
        
}

    /*   func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    collectionViewLayout.invalidateLayout()
    let photoFrameSize = CGSizeMake(photoCollectionView.frame.size.width, photoCollectionView.frame.size.height)
    print("layout photoFrameSize [\(indexPath.row)]: \(photoFrameSize)")
    return photoFrameSize
    
    } */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

