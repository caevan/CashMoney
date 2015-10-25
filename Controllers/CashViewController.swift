//
//  CashViewController.swift
//  Cash Money
//
//  Created by Caevan Sachinwalla on 24/10/2015.
//  Copyright © 2015 AMKD Pty Ltd. All rights reserved.
//

import UIKit
import Foundation

private let cueeencyCellReuseIdentifier = "CurrencyCollectionViewCell"
private let chooseCurrency: [String] = ["CAD", "EUR", "GBP", "JPY", "USD"]
private let collectionCellWidth:CGFloat = 126.0
private let cashGreen = UIColor(red: 58/255, green: 206/255, blue: 128/255, alpha: 1)
private let currencySign = "$"

class CashViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate{

    
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    
    @IBOutlet weak var txtFromCurrency: UITextField!
    
    
    @IBOutlet weak var txtToCurrency: UILabel!
    var currenncyRates:[String:NSNumber]?
    var currentCurrencyIndex:Int = 0;
    var rates = [CashModel]()
//    var cashRates: Dictionary<String, AnyObject>()
    var conversionRates = Dictionary<String,NSNumber?>();


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currencyCollectionView.dataSource = self;
        currencyCollectionView.delegate = self;
        txtFromCurrency.delegate = self;
        self.getCurrencyRates()
        
        let border = self.addDashedBorderWithColor(UIColor.blackColor().CGColor, textField: self.txtFromCurrency)
        self.txtFromCurrency.layer.addSublayer(border)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        convertCurrency(self.txtFromCurrency.text!)
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
        else {
            cell.lblCurrency.textColor = cashGreen
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
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            let totalItems = chooseCurrency.count;
            
            let viewWidth:CGFloat = collectionView.frame.width;
            let cellWidth:CGFloat = collectionCellWidth
            let itemsInFrame = viewWidth/(cellWidth+1)
            if(Int(itemsInFrame) <= totalItems)
            {
                if(currentCurrencyIndex < Int(itemsInFrame))
                {
                    if(currentCurrencyIndex > Int(itemsInFrame/2)){
                        let inset = (viewWidth/2) - ((cellWidth+1) * (itemsInFrame-CGFloat(currentCurrencyIndex)))
                       return UIEdgeInsetsMake(0, 0, 0, inset)
                        
                    }
                    else if(currentCurrencyIndex <= Int(itemsInFrame/2))
                    {
                        let inset = (viewWidth/2) - ((cellWidth+1)/2) - ((cellWidth+1)*CGFloat(currentCurrencyIndex))
 //                       let inset = (viewWidth/2) - ((cellWidth+1) * CGFloat(currentCurrencyIndex))
                        return UIEdgeInsetsMake(0, inset, 0, 0)
                        
                    }
                    else
                    {
                        return UIEdgeInsetsMake(0, 0, 0, 0)
                        
                    }
                    //                   let inset = (viewWidth/2) - (cellWidth+1)
                    //                   return UIEdgeInsetsMake(0, inset, 0, 0)
                    
                }
                else if((totalItems-currentCurrencyIndex) < Int(itemsInFrame)){
                    let inset = cellWidth+1
//                    let inset = (viewWidth/2) - (cellWidth+1) * CGFloat(totalItems-currentCurrencyIndex)
                    return UIEdgeInsetsMake(0, 0, 0, inset)
                    
                }
                else
                {
                    return UIEdgeInsetsMake(0,0, 0, 0)
                    
                }
            }
            else
            {
                let inset = viewWidth - itemsInFrame*(cellWidth+1)
                return UIEdgeInsetsMake(0, inset/2, 0, inset/2)
                
            }
        
    
    }
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        currentCurrencyIndex = indexPath.row;
        let newIndex = NSIndexPath(forRow: currentCurrencyIndex, inSection: 0)
        
        collectionView.reloadData()
        self.currencyCollectionView.layoutIfNeeded()
        self.currencyCollectionView.scrollToItemAtIndexPath(newIndex, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        self.convertCurrency(txtFromCurrency.text!)
    }

    // MARK: UITextViewDelegate
    // Adds $ before the text, e.g. "1" -> "$1" and allows "." and ","
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        var value = textField.text
        
        let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "1234567890,.").invertedSet)
        
        let decimalString = components.joinWithSeparator("")

        let length = decimalString.characters.count


        if length > 0 {
            value = "\(currencySign)\(decimalString)"
        }
        else {
            value = ""
        }
        textField.text = value
        self.convertCurrency(value!)
       return false
    }
    
    // Formats final value using current locale, e.g. "130,50" -> "$130", "120.70" -> "$120.70", "5" -> "$5.00"
    func textFieldDidEndEditing(textField: UITextField) {
        let value = textField.text
        let components = value!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "1234567890,.").invertedSet)
        let decimalString = components.joinWithSeparator("")
        
        let number = NSDecimalNumber(string: decimalString, locale:NSLocale.currentLocale())
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        
        if let formatedValue = formatter.stringFromNumber(number) {
            textField.text = formatedValue
            self.convertCurrency(formatedValue)
        }
        else {
            textField.text = ""
        }
    }
    
    func currencyStringToDecimal(formatedString:String) -> NSDecimalNumber
    {
        let components = formatedString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "1234567890,.").invertedSet)
        let decimalString = components.joinWithSeparator("")
        
        let number = NSDecimalNumber(string: decimalString, locale:NSLocale.currentLocale())
        
        return number
    }
    /*   func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    collectionViewLayout.invalidateLayout()
    let photoFrameSize = CGSizeMake(photoCollectionView.frame.size.width, photoCollectionView.frame.size.height)
    print("layout photoFrameSize [\(indexPath.row)]: \(photoFrameSize)")
    return photoFrameSize
    
    } */
    func getCurrencyRates()
    {
//        var cashRates: Dictionary<String, AnyObject>
        CurrencyRepository.getCurencyFromServerWithSuccess { (currencyData) -> Void in
            let json = JSON(data: currencyData)
            print("getCurencyFromServerWithSuccess: \(json)")
            if let ratesData = json["rates"].dictionary
            {
                print("viewdidLoad rates: \(ratesData)")
                
                //3
                for rate in ratesData {
                    print("rate: \(rate) ")
                    let country:String? = rate.0
                    let countryRate:NSNumber? = rate.1.number
                    
                    let cashRate = CashModel(country: country, rate: countryRate)
                    self.rates.append(cashRate)
                    self.conversionRates[country!] = countryRate
                }
                print(self.rates)
                let myRate = self.rates[0]
                print(myRate.country)
                //4
                //                print(apps)
                //                self.setupCollectionView()
                
            }
            print("All Rates \(self.conversionRates)")
            self.currencyCollectionView.reloadData()
            let myRate = self.conversionRates["USD"]
            print("currency: \(myRate)")
          
            
            if let currencyValue = json["rates"]["USD"].number {
                print("NSURLSession: \(currencyValue)")
            }
        }
    }
    func convertCurrency(fromCurrencyText:String){
        if let rate = self.conversionRates[chooseCurrency[currentCurrencyIndex]]{
            let fromCurrency = currencyStringToDecimal(fromCurrencyText)
            let convertedCurrency = (fromCurrency.doubleValue)  * (rate?.doubleValue)!
            
            txtToCurrency.text = formatCurrency(convertedCurrency, locale: localeFromCode(chooseCurrency[currentCurrencyIndex]))
        }

    }
    func formatCurrency(currencyValue:NSNumber, locale:String) -> String
    {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: locale)
        return formatter.stringFromNumber(currencyValue)!

    }
    func localeFromCode(countryCode:String) -> String
    {
        switch(countryCode)
        {
            case "USD": return "en_US"
            case "JPY": return "ja_JP"
            case "GBP": return "cy_GB"
            case "EUR": return "de_DE"
            case "CAD": return "en_US"
        default: return "en_US"
        }
    }
    func addDashedBorderWithColor(color:CGColorRef, textField: UITextField) ->CAShapeLayer {
    let shapeLayer = CAShapeLayer();
    
    let frameSize = textField.frame.size;
    
    let shapeRect = CGRectMake(0.0, 0.0, frameSize.width, 1);
    shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPointMake(textField.frame.origin.x,textField.frame.origin.y+frameSize.height)
    shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 5.0
        shapeLayer.lineJoin = kCALineJoinRound
//        shapeLayer.lineDashPattern = 1
        shapeLayer.lineDashPattern = [4, 2];

//     [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
//    [NSNumber numberWithInt:5],
//    nil]];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:15.0];
//    [shapeLayer setPath:path.CGPath];
    
    return shapeLayer;
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

