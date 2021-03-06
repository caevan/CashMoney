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
let ratesLoadedNotification = "ratesLoadedNotification"

class CashViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate{

    
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    
    @IBOutlet weak var txtFromCurrency: UITextField!
    
    
    @IBOutlet weak var txtToCurrency: UILabel!
    var currentCurrencyIndex:Int = 0;
    var conversionRates = Dictionary<String,NSNumber?>();


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currencyCollectionView.dataSource = self;
        currencyCollectionView.delegate = self;
        txtFromCurrency.delegate = self;
        self.addDoneToolBarToKeyboard(txtFromCurrency)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "RatesLoaded", name: ratesLoadedNotification, object: nil);
        self.getCurrencyRates()
        
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let border = CAShapeLayer()
        let width = CGFloat(3.0)
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, txtFromCurrency.frame.size.height);
        CGPathAddLineToPoint(path, nil, txtFromCurrency.frame.size.width, txtFromCurrency.frame.size.height);
        // Add a dotted line at the bottom of the text field
        border.path = path
        border.borderColor = UIColor.clearColor().CGColor
        border.frame = CGRect(x: 0, y: 0, width:  txtFromCurrency.frame.size.width, height: txtFromCurrency.frame.size.height)
       
        border.borderWidth = width
        border.lineDashPattern = [4, 4];
        border.fillColor = UIColor.clearColor().CGColor;
        border.strokeColor = UIColor.blackColor().CGColor;
        border.lineWidth = width;
       
        txtFromCurrency.layer.addSublayer(border)
        txtFromCurrency.layer.masksToBounds = false

    }
    func RatesLoaded()
    {
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
 
            // Following code is required to correctly centre th selected item in the collectionview.
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
                       return UIEdgeInsetsMake(0, inset, 0, 0)
                        
                    }
                    else
                    {
                        return UIEdgeInsetsMake(0, 0, 0, 0)
                        
                    }
                    
                }
                else if((totalItems-currentCurrencyIndex) < Int(itemsInFrame)){
                    let inset = cellWidth+1
                    return UIEdgeInsetsMake(0, 0, 0, inset)
                    
                }
                else
                {
                    return UIEdgeInsetsMake(0,0, 0, 0)
                    
                }
            }
            else
            {

                if(currentCurrencyIndex < Int(itemsInFrame))
                {
                    if(currentCurrencyIndex > Int(itemsInFrame/2)){
                        let inset = (viewWidth/2) - ((cellWidth+1)/2) - ((cellWidth+1) * CGFloat(Int(itemsInFrame)-(currentCurrencyIndex+2)))
                        return UIEdgeInsetsMake(0, 0, 0, inset)
                        
                    }
                    else if(currentCurrencyIndex <= Int(itemsInFrame/2))
                    {
                        let inset = (viewWidth/2) - ((cellWidth+1)/2) - ((cellWidth+1)*CGFloat(currentCurrencyIndex))
                        return UIEdgeInsetsMake(0, inset, 0, 0)
                        
                    }
                    else
                    {
                        return UIEdgeInsetsMake(0, 0, 0, 0)
                        
                    }
                    
                }
                else if((totalItems-currentCurrencyIndex) < Int(itemsInFrame)){
                    let inset = cellWidth+1
                    return UIEdgeInsetsMake(0, 0, 0, inset)
                    
                }
                else
                {
                    return UIEdgeInsetsMake(0,0, 0, 0)
                    
                }
                
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
        var value = textField.text
        if(value == ""){
            value = "$0.00"
        }
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
    /*
    **  func currencyStringToDecimal(formatedString:String)
    **  function takes a decimal formatted number and returns an NSDecimalNumber
    */
    func currencyStringToDecimal(formatedString:String) -> NSDecimalNumber
    {
        let components = formatedString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "1234567890.").invertedSet)
        let decimalString = components.joinWithSeparator("")
        
        let number = NSDecimalNumber(string: decimalString, locale:NSLocale.currentLocale())
        
        return number
    }
    
    //MARK: Currency function
    /*
    **     func getCurrencyRates()
    **      Function retrieves the currency coversion rates and stores the rates
    **      the dictionary conversionRates
    */
    func getCurrencyRates()
    {
        CurrencyRepository.getCurencyFromServerWithSuccess { (currencyData) -> Void in
            let json = JSON(data: currencyData)
            if let ratesData = json["rates"].dictionary
            {
                
                //3
                for rate in ratesData {
                    let country:String? = rate.0
                    let countryRate:NSNumber? = rate.1.number
                    
                    self.conversionRates[country!] = countryRate
                }
                
            }
            NSNotificationCenter.defaultCenter().postNotificationName(ratesLoadedNotification, object: self)
         
            
        }
    }
    /*
    **  func convertCurrency(fromCurrencyText:String)
    **  Converts the value in the parameter fromCurrencyText:String
    **  to the currency currently selected. Resulting text is place formatted and
    **  placed in the txtToCurrency field
    */
    func convertCurrency(fromCurrencyText:String){
        if let rate = self.conversionRates[chooseCurrency[currentCurrencyIndex]]{
            let fromCurrency = currencyStringToDecimal(fromCurrencyText)
            let convertedCurrency = (fromCurrency.doubleValue)  * (rate?.doubleValue)!
            
            txtToCurrency.text = formatCurrency(convertedCurrency, locale: localeFromCode(chooseCurrency[currentCurrencyIndex]))
        }

    }
    /*
    **  formatCurrency(currencyValue:NSNumber, locale:String)
    **  Formats the value in parameter currencyValue in the selected locale
    **  Returns the formatted string
    */
    func formatCurrency(currencyValue:NSNumber, locale:String) -> String
    {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: locale)
        return formatter.stringFromNumber(currencyValue)!

    }
    /*
    **   localeFromCode(countryCode:String) -> String
    **   Converts the currency country code to a locale used by NSLocale
    **   For EURO we only need the EURO symbol and the correct format so
    **   any country locale which uses the Euro is suitable. Since Canada also uses the 
    **   Dollar symbol US locale will suffice.
    */
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
    /*
    ** func addDoneToolBarToKeyboard(textView:UITextField)
    ** functions adds a done or close button to the the keyboard of a designated
    ** UITextfield
    */
    func addDoneToolBarToKeyboard(textView:UITextField)
    {
        let doneToolbar:UIToolbar =  UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent;
        
        doneToolbar.items = (NSArray(objects:UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonClickedDismissKeyboard"))) as! [UIBarButtonItem]);
        doneToolbar.sizeToFit();
        textView.inputAccessoryView = doneToolbar;
        
    }
    /*
    ** func doneButtonClickedDismissKeyboard()
    ** OnClick function for keybord done button. Dismisses keyboard
    */
    func doneButtonClickedDismissKeyboard()
    {
        txtFromCurrency.resignFirstResponder();
        if(txtFromCurrency.text == "NaN")
        {
            txtFromCurrency.text = "$0.00"
        }
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

