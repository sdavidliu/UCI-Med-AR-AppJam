//
//  Simeon.swift
//  David Test AR App
//
//  Created by Simeon Lam on 11/8/17.
//  Copyright © 2017 David Liu. All rights reserved.
//

import UIKit

class Simeon: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var sim: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        // Do any additional setup after loading the view.
        
        var request = URLRequest(url: URL(string: "https://secure.getbottlestonight.com/api/v4/venues/460/sections?date=2017-11-08T10:54:38.050-08:00")!)
        
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        */
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func butaction1(_ sender: Any) {
        if sim.text == "Simeon" {
            sim.text = "Michael sucks"
        }
        else {
            sim.text = "Simeon"
        }
        //UIApplication.shared.openURL(URL(string: "http://maps.apple.com/?address=1600,PennsylvaniaAve.,20500")!)
        UIApplication.shared.open(URL(string: "http://maps.apple.com/?q=Hospital")!, options: [:], completionHandler: nil)

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
