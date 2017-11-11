//
//  SettingsViewController.swift
//  ARKitInteraction
//
//  Created by David Liu on 11/9/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var doctorEmailTextField: UITextField!
    @IBOutlet weak var ccEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.layer.cornerRadius = 10
        
        nameTextField.delegate = self
        birthdayTextField.delegate = self
        weightTextField.delegate = self
        heightTextField.delegate = self
        doctorEmailTextField.delegate = self
        ccEmailTextField.delegate = self
        
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "name") != nil) {
            nameTextField.text = defaults.string(forKey: "name")
        }
        if (defaults.string(forKey: "birthday") != nil) {
            birthdayTextField.text = defaults.string(forKey: "birthday")
        }
        if (defaults.string(forKey: "weight") != nil) {
            weightTextField.text = defaults.string(forKey: "weight")
        }
        if (defaults.string(forKey: "height") != nil) {
            heightTextField.text = defaults.string(forKey: "height")
        }
        if (defaults.string(forKey: "doctoremail") != nil) {
            doctorEmailTextField.text = defaults.string(forKey: "doctoremail")
        }
        if (defaults.string(forKey: "ccemail") != nil) {
            ccEmailTextField.text = defaults.string(forKey: "ccemail")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func doneAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(nameTextField.text, forKey: "name")
        defaults.set(birthdayTextField.text, forKey: "birthday")
        defaults.set(weightTextField.text, forKey: "weight")
        defaults.set(heightTextField.text, forKey: "height")
        defaults.set(doctorEmailTextField.text, forKey: "doctoremail")
        defaults.set(ccEmailTextField.text, forKey: "ccemail")
        UserDefaults.standard.synchronize()
        
        self.dismiss(animated: true, completion: nil)
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
