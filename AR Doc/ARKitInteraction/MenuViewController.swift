//
//  MenuViewController.swift
//  ARKitInteraction
//
//  Created by David Liu on 11/9/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterButton.layer.cornerRadius = 10
        settingsButton.layer.cornerRadius = 10
        
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "name") == nil) {
            defaults.set("", forKey: "name")
        }
        if (defaults.string(forKey: "birthday") == nil) {
            defaults.set("", forKey: "birthday")
        }
        if (defaults.string(forKey: "weight") == nil) {
            defaults.set("", forKey: "weight")
        }
        if (defaults.string(forKey: "height") == nil) {
            defaults.set("", forKey: "height")
        }
        if (defaults.string(forKey: "doctoremail") == nil) {
            defaults.set("", forKey: "doctoremail")
        }
        if (defaults.string(forKey: "ccemail") == nil) {
            defaults.set("", forKey: "ccemail")
        }
        defaults.synchronize()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
