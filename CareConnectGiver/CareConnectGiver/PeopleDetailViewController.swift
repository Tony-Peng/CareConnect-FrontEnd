//
//  PeopleDetailViewController.swift
//  CareConnectGiver
//
//  Created by Tony on 3/3/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit

class PeopleDetailViewController: UIViewController {
    var getname = String()
    var getId = Int()
    
    let map = [
        "shower": 1,
        "park": 2,
        "chess": 3,
        "breakfast": 4
    ]
    
    @IBOutlet weak var elderlyName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elderlyName.textAlignment = NSTextAlignment.center
        elderlyName.text! = getname
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    func createNewActivity(activityType: String) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = Storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        destinationVC.getElderlyId = getId
        //TODO: THis is hardcoded to shower
        destinationVC.getActivityType = map[activityType]!
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    @IBAction func goToSurvey(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = Storyboard.instantiateViewController(withIdentifier: "SurveyViewController") as! SurveyViewController
        
        destVC.elderlyId = self.getId
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func breakfastAction(_ sender: Any) {
        createNewActivity(activityType: "breakfast")
    }
    
    @IBAction func parkAction(_ sender: Any) {
        createNewActivity(activityType: "park")
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
    
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
