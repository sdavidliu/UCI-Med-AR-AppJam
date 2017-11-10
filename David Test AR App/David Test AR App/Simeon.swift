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

        // Do any additional setup after loading the view.
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
