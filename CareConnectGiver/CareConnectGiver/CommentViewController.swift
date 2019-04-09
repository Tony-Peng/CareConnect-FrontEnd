//
//  CommentViewController.swift
//  CareConnectGiver
//
//  Created by Andre Hijaouy on 4/8/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit
import Alamofire

class CommentViewController: UIViewController {

    var person: Person?
    var caretakerId = 1 // hard coded until we add login functionality
    @IBOutlet weak var commentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentText.layer.borderColor = UIColor.black.cgColor
        self.commentText.layer.borderWidth = 1
        self.commentText.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    

    @IBAction func submitComment(_ sender: Any) {
        let parameters = [
            "note": self.commentText?.text,
            "elderly": self.person?.id,
            "caretaker": caretakerId
            ] as [String : Any]
        
        let url = "https://mas-care-connect.herokuapp.com/comments/"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
