//
//  PeopleDetailViewController.swift
//  CareConnectGiver
//
//  Created by Tony on 3/3/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PeopleDetailViewController: UIViewController {
    
    var person: Person?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = self.person?.name
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.loadProfilePicture()
    }
    
    func loadProfilePicture() {
        self.profilePic.image = self.person?.picture
        self.profilePic.layer.borderWidth = 1
        self.profilePic.layer.masksToBounds = false
        self.profilePic.layer.borderColor = UIColor.white.cgColor
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height / 2
        self.profilePic.clipsToBounds = true
    }
    
    func postActivityToAPI(activityType: String) {
        let getURL = "https://mas-care-connect.herokuapp.com/activitytypes/?name=" + activityType
        print(getURL)
        var activityTypeId = Int()
        Alamofire.request(getURL, method: .get).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                activityTypeId = json[0]["id"].int!
                let parameters = [
                    "duration": 60,
                    "activityType": activityTypeId,
                    "elderly": self.person?.id,
                    "caretaker": 1
                    ] as [String: Any]
                
                let url = "https://mas-care-connect.herokuapp.com/activities/"
                Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
                    switch response.result {
                    case .success:
                        print(response)
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    func createNewActivity(activityType: String) {
        let msg = String(format: "%@%@%@", "Are you sure you want to add a new ", activityType, " activity?")
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {action in
            self.postActivityToAPI(activityType: activityType)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goToComment(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = Storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        
        destVC.person = self.person
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func goToSurvey(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = Storyboard.instantiateViewController(withIdentifier: "SurveyViewController") as! SurveyViewController
        
        destVC.person = self.person
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func breakfastAction(_ sender: Any) {
        createNewActivity(activityType: "breakfast")
    }
    @IBAction func lunchAction(_ sender: Any) {
        createNewActivity(activityType: "lunch")
    }
    
    @IBAction func dinnerAction(_ sender: Any) {
        createNewActivity(activityType: "dinner")
    }
    @IBAction func medicineAction(_ sender: Any) {
        createNewActivity(activityType: "medicine")
    }
    
    @IBAction func showerAction(_ sender: Any) {
        createNewActivity(activityType: "shower")
    }
    
    @IBAction func napAction(_ sender: Any) {
        createNewActivity(activityType: "nap")
    }
    @IBAction func outingAction(_ sender: Any) {
        createNewActivity(activityType: "outing")
    }
    @IBAction func artmusicAction(_ sender: Any) {
        createNewActivity(activityType: "artmusic")
    }
    
    @IBAction func exerciseAction(_ sender: Any) {
        createNewActivity(activityType: "exercise")
    }
    @IBAction func gameAction(_ sender: Any) {
        createNewActivity(activityType: "game")
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
