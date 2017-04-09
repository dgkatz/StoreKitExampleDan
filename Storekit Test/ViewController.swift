//
//  ViewController.swift
//  Storekit Test
//
//  Created by Daniel Katz on 4/1/17.
//  Copyright © 2017 Stratton Innovations. All rights reserved.
//

import UIKit
import StoreKit
class ViewController: UIViewController {
    @IBOutlet weak var level2Button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //set the homeViewController object defined in app delegate to self
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.homeViewController = self
    }
    
    func enableLevel2() {
        //this function enables the Next Level button to be clicked
        level2Button.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

