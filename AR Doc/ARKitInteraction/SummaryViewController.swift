//
//  SummaryViewController.swift
//  ARKitInteraction
//
//  Created by David Liu on 11/9/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import MessageUI

class SummaryViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    var results = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(results)
        
        sendEmailButton.layer.cornerRadius = 10
        homeButton.layer.cornerRadius = 10
        backButton.layer.cornerRadius = 10
        
        //summaryLabel.text = "Summary: Back pain\nLocation: Lower back\nRadiation: No\nSeverity (on scale of 10): 7\nOnset: 2 weeks ago\nDuration: 30 minutes\nFrequency: 3 times a day\nProgression: More frequently each day\nSymptoms: Pain in muscles and bones. Occasional muscle spasms. Back Joint dysfunction."
        var summaryText = "Questionnaire Results:\n"
        for r in results {
            if let answer = r.value as? String {
                summaryText += r.key + ": " + answer + "\n"
            }else if let answer = r.value as? Array<String>{
                summaryText += r.key + ": " + answer.joined(separator: ", ") + "\n"
            }else if let answer = r.value as? Dictionary<String,Any>{
                summaryText += r.key + ": " + (answer["Other"] as! String) + "\n"
            }
        }
        summaryLabel.text = summaryText
        summaryLabel.sizeToFit()
        
        summaryTextView.layer.cornerRadius = 10
        summaryTextView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            var name = ""
            var birthday = ""
            var weight = ""
            var height = ""
            var doctorEmail = ""
            var ccEmail = ""
            var basicInfo = ""
            var otherComments = ""
            
            let defaults = UserDefaults.standard
            if (defaults.string(forKey: "name") != "") {
                name = defaults.string(forKey: "name")!
                basicInfo += "Name: " + name + "\n"
            }
            if (defaults.string(forKey: "birthday") != "") {
                birthday = defaults.string(forKey: "birthday")!
                basicInfo += "Birthday: " + birthday + "\n"
            }
            if (defaults.string(forKey: "weight") != "") {
                weight = defaults.string(forKey: "weight")!
                basicInfo += "Weight: " + weight + "\n"
            }
            if (defaults.string(forKey: "height") != "") {
                height = defaults.string(forKey: "height")!
                basicInfo += "Height: " + height + "\n"
            }
            if (defaults.string(forKey: "doctoremail") != "") {
                doctorEmail = defaults.string(forKey: "doctoremail")!
            }
            if (defaults.string(forKey: "ccemail") != "") {
                ccEmail = defaults.string(forKey: "ccemail")!
            }
            
            if (basicInfo != "") {
                basicInfo = "Basic Info:\n" + basicInfo + "\n"
            }
            if (summaryTextView.text != "") {
                otherComments = "\nAdditional information:\n" + summaryTextView.text
            }
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            mail.setToRecipients([doctorEmail])
            mail.setCcRecipients([ccEmail])
            mail.setSubject("AR Doc App Medical Report")
            mail.setMessageBody(basicInfo + summaryLabel.text! + otherComments, isHTML: false)
            if (defaults.bool(forKey: "picture") == true) {
                if let image = getSavedImage(named: "fileName") {
                    let imageData: Data = UIImagePNGRepresentation(image)!
                    mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "ardocscreenshot")
                }
            }
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    @IBAction func homeAction(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hospitalAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://maps.apple.com/?q=Hospital")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func pharmacyAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://maps.apple.com/?q=Pharmacy")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func dentistAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://maps.apple.com/?q=Physical+Therapy")!, options: [:], completionHandler: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
