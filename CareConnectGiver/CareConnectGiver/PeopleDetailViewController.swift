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
    
    @IBOutlet weak var elderlyName: UILabel!
    @IBOutlet weak var showerButton: UIButton!
    @IBAction func showerAction(_ sender: UIButton) {
        print("HELLO")
        performSegue(withIdentifier: "newActivity", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let showerImage = #imageLiteral(resourceName: "shower")
        showerButton.setImage(showerImage, for: [])
        elderlyName.textAlignment = NSTextAlignment.center
        elderlyName.text! = getname
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
           // name = carName.text!
        }
    }
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
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
