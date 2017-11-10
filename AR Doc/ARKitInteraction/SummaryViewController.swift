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
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendEmailButton.layer.cornerRadius = 10
        homeButton.layer.cornerRadius = 10
        
        summaryLabel.text = "Summary: Back pain\nLocation: Lower back\nRadiation: No\nSeverity (on scale of 10): 7\nOnset: 2 weeks ago\nDuration: 30 minutes\nFrequency: 3 times a day\nProgression: More frequently each day\nSymptoms: Pain in muscles and bones. Occasional muscle spasms. Back Joint dysfunction."
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
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            mail.setToRecipients(["doctor@kaiser.org"])
            mail.setCcRecipients(["mom@gmail.com"])
            mail.setSubject("AR Doc Report")
            mail.setMessageBody(summaryLabel.text! + "\n\nOther comments:\n" + summaryTextView.text, isHTML: false)
            if let image = getSavedImage(named: "fileName") {
                let imageData: Data = UIImagePNGRepresentation(image)!
                mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "ardocscreenshot")
            }
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    @IBAction func homeAction(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
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
