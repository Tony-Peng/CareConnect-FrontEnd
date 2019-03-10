//
//  ActivityViewController.swift
//  CareConnectGiver
//
//  Created by Michael Chen on 3/10/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class ActivityViewController: UIViewController {
    
    var getElderlyId = Int()
    var getActivityType = Int()
    @IBOutlet weak var durationPicker: UIDatePicker!
    @IBAction func submitActivity(_ sender: Any) {
        let parameters = [
            "duration": durationPicker.countDownDuration,
            "activityType" : getActivityType,
            "elderly" : getElderlyId,
            "caretaker" : 1
            ] as [String : Any]

        let url = "https://mas-care-connect.herokuapp.com/activities/"
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
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDatePicker.Mode.countDownTimer
        durationPicker.countDownDuration = 60
        print("In viewDidLoad ")
        print(getElderlyId)
        // Do any additional setup after loading the view.
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
