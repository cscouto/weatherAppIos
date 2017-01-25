//
//  SettingsViewController.swift
//  weatherApp
//
//  Created by Tiago Henrique on 1/3/17.
//  Copyright © 2017 Tiago Henrique. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet var zipcode: UITextField!
    @IBOutlet var type: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let zip = UserDefaults().string(forKey: "zipcode"){
            zipcode.text = "\(zip)"
        }
        
        let measure = UserDefaults().integer(forKey: "type")
        type.selectedSegmentIndex = measure
        
    }
    
    @IBAction func btnSavePressed(_ sender: UIButton) {
        UserDefaults.standard.set(zipcode.text, forKey: "zipcode")
        UserDefaults.standard.set(type.selectedSegmentIndex, forKey: "type")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
