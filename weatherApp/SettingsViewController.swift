//
//  SettingsViewController.swift
//  weatherApp
//
//  Created by Tiago Henrique on 1/3/17.
//  Copyright © 2017 Tiago Henrique. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var zipcode: UITextField!
    @IBOutlet var type: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func saveStatus(_ sender: Any) {
        UserDefaults.standard.set(zipcode.text, forKey: "zipcode")
        UserDefaults.standard.set(type.selectedSegmentIndex, forKey: "type")
    }

}
