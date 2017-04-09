//
//  PurchaseViewController.swift
//  Storekit Test
//
//  Created by Daniel Katz on 4/1/17.
//  Copyright © 2017 Stratton Innovations. All rights reserved.
//

import UIKit
import StoreKit
class PurchaseViewController: UIViewController,SKPaymentTransactionObserver,SKProductsRequestDelegate {
    var product: SKProduct?
    var productID = "com.strattondesign.StorekitTest.level3"
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initially disable buyButton, until IAP info is retreived
        buyButton.isEnabled = false
        
        //Add self as observer to the payment que
        SKPaymentQueue.default().add(self)
        
        //retreive IAP information
        getProductInfo()
    }
    
    func getProductInfo()
    {
        //First determine if making payemnts is possible
        if SKPaymentQueue.canMakePayments() {
            //create and send request for IAP info with productID as a param
            let request = SKProductsRequest(productIdentifiers:
                NSSet(objects: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            //failed to get IAP info, so set to default text
            productDescription.text =
            "Please enable In App Purchase in Settings"
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //callback function when the Apple App Store responds to the product request
        
        var products = response.products
        
        //Check to make sure there is a product returned
        if (products.count != 0) {
            //products is a list so need to get first object
            product = products[0]
            
            //enable the buy button now that information has been received
            buyButton.isEnabled = true
            
            //set title and decription from retreived product info
            productTitle.text = product!.localizedTitle
            productDescription.text = product!.localizedDescription
            
        } else {
            //products is empty - no IAP matching the product ID
            productTitle.text = "Product not found"
        }
        
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids
        {
            print("Product not found: \(product)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //callback function when transaction state has changed
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                //if the transaction has been completed(purchased)
                self.unlockFeature()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
                //if the trasnaction has failed
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func unlockFeature() {
        //function called when purchase has been made
        
        //call enableLevel2 function defined in ViewController class
        let appdelegate = UIApplication.shared.delegate
            as! AppDelegate
        appdelegate.homeViewController!.enableLevel2()
        
        //update info after purchase
        buyButton.isEnabled = false
        productTitle.text = "Item has been purchased"
    }
    
    @IBAction func buyProduct(_ sender: Any) {
        //send payment request
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
