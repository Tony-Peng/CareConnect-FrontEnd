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
    
    var person: Person?
    var caretakerId = 1 // hard coded until we add login functionality

    // MARK: Outlets
    @IBOutlet weak var q1: UISegmentedControl!
    @IBOutlet weak var q2: UISegmentedControl!
    @IBOutlet weak var q3: UISegmentedControl!
    @IBOutlet weak var q4: UISegmentedControl!
    @IBOutlet weak var q5: UISegmentedControl!
    @IBOutlet weak var q6: UISegmentedControl!
    @IBOutlet weak var q7: UISegmentedControl!
    @IBOutlet weak var q8: UISegmentedControl!
    
    func getQ1() -> Bool {
        return self.q1.selectedSegmentIndex == 0
    }
    func getQ2() -> Bool {
        return self.q2.selectedSegmentIndex == 0
    }
    
    func getQ3() -> Bool {
        return self.q3.selectedSegmentIndex == 0
    }
    
    func getQ4() -> Bool {
        return self.q4.selectedSegmentIndex == 0
    }

    func getQ5() -> Bool {
        return self.q5.selectedSegmentIndex == 0
    }

    func getQ6() -> Bool {
        return self.q6.selectedSegmentIndex == 0
    }

    func getQ7() -> Int {
        if (q7.selectedSegmentIndex == 0) {
            return 1
        } else if (q7.selectedSegmentIndex == 1) {
            return 0
        }
        return -1
    }
    
    func getQ8() -> Int {
        return q8.selectedSegmentIndex
    }
    
    @IBAction func submitSurvey(_ sender: Any) {
        let msg = "By agreeing, I certify all information is true and correct to the best of my knowledge."
        let alert = UIAlertController(title: "Confirmation", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Agree", style: UIAlertAction.Style.default, handler: self.sendSurveyToAPI))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func sendSurveyToAPI(action: UIAlertAction) {
        let parameters = [
            "q1_attentive": self.getQ1(),
            "q2_hope": self.getQ2(),
            "q3_empathetic": self.getQ3(),
            "q4_humor": self.getQ4(),
            "q5_anxiety": self.getQ5(),
            "q6_sleep": self.getQ6(),
            "q7_appetite": getQ7(),
            "q8_mood": getQ8(),
            "elderly": self.person?.id,
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
