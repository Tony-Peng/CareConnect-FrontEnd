//
//  SurveyViewController.swift
//  CareConnectGiver
//
//  Created by Andre Hijaouy on 3/24/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var q1: UISwitch!
    @IBOutlet weak var q2: UISwitch!
    @IBOutlet weak var q3: UISwitch!
    @IBOutlet weak var q4: UISwitch!
    @IBOutlet weak var q5: UISwitch!
    @IBOutlet weak var q6: UISwitch!
    @IBOutlet weak var q7: UISegmentedControl!
    @IBOutlet weak var q8: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitSurvey(_ sender: Any) {
        // TODO
        print("Q1: \(q1.isOn)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
