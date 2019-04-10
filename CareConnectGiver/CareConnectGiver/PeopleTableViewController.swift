//
//  PeopleTableViewController.swift
//  CareConnectGiver
//
//  Created by Tony on 3/3/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON

class PeopleTableViewController: UITableViewController {
    var persons = [Person]()
    let cellId = "peopleCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://mas-care-connect.herokuapp.com/elderlies/", method: .get).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                for (_,v) in json {
                    let name = v["name"].string!
                    let id = v["id"].int!
                    let pictureString = v["picture"].string!
                    let picture = UIImage(named: pictureString)!
                    let birth_date = v["birth_date"].string!
                    let temp = Person(id: id, name: name, picture: picture, birth_date: birth_date)
                    self.persons.append(temp)
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
       self.tableView.delegate = self
       self.tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.persons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PersonTableViewCell
        cell.person = self.persons[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "PeopleDetailViewController") as! PeopleDetailViewController
        DvC.person = self.persons[indexPath.row]
        self.navigationController?.pushViewController(DvC, animated: true)
    }
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    

    @IBAction func done(segue:UIStoryboardSegue) {
       //  let carDetailVC = segue.source as! PeopleDetailViewController
       /*
        newCar = carDetailVC.name
        
        cars.append(newCar)
        tableView.reloadData()
         */
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
