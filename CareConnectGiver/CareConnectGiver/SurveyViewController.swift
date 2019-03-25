//
//  SurveyViewController.swift
//  CareConnectGiver
//
//  Created by Andre Hijaouy on 3/24/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit
import Alamofire

class SurveyViewController: UIViewController {
    
    var elderlyId = Int()
    var caretakerId = 1 // hard coded until we add login functionality

    // MARK: Outlets
    @IBOutlet weak var q1: UISwitch!
    @IBOutlet weak var q2: UISwitch!
    @IBOutlet weak var q3: UISwitch!
    @IBOutlet weak var q4: UISwitch!
    @IBOutlet weak var q5: UISwitch!
    @IBOutlet weak var q6: UISwitch!
    @IBOutlet weak var q7: UISegmentedControl!
    @IBOutlet weak var q8: UISegmentedControl!
    
    
    func getQ7() -> Bool {
        return q7.selectedSegmentIndex == 0
    }
    
    func getQ8() -> Int {
        return q8.selectedSegmentIndex
    }
    
    @IBAction func submitSurvey(_ sender: Any) {
        let parameters = [
            "q1_attentive": q1.isOn,
            "q2_hope": q2.isOn,
            "q3_empathetic": q3.isOn,
            "q4_humor": q4.isOn,
            "q5_anxiety": q5.isOn,
            "q6_sleep": q6.isOn,
            "q7_appetite": getQ7(),
            "q8_mood": getQ8(),
            "elderly": elderlyId,
            "caretaker": caretakerId
            ] as [String : Any]
        
        let url = "https://mas-care-connect.herokuapp.com/quizresponses/"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error)
            }
            
        }
        _ = navigationController?.popViewController(animated: true)
    }

}
