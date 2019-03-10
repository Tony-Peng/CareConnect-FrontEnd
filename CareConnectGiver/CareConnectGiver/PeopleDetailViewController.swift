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
    
    @IBOutlet weak var elderlyName: UILabel!
    @IBOutlet weak var showerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let showerImage = #imageLiteral(resourceName: "shower")
        showerButton.setImage(showerImage, for: [])
        elderlyName.textAlignment = NSTextAlignment.center
        elderlyName.text! = getname
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func showerAction(_ sender: Any) {
        print("preparing")
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = Storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        destinationVC.getElderlyId = getId
        //TODO: THis is hardcoded to shower
        destinationVC.getActivityType = 1
        self.navigationController?.pushViewController(destinationVC, animated: true)
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
