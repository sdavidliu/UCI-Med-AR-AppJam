//
//  ViewController.swift
//  first test
//
//  Created by Tiffany Yu on 11/11/17.
//  Copyright © 2017 Tiffany Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myLabel.text = "label1"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(_ sender: Any) {
        if myLabel.text == "pressed"{
            myLabel.text = "label1"
        }
        else{
            myLabel.text = "pressed"
        }
    }
    
}

