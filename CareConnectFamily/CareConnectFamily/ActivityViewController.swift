//
//  ActivityViewController.swift
//  CareConnectFamily
//
//  Created by Michael Chen on 3/10/19.
//  Copyright © 2019 Michael Chen. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

struct Activity {
    let desc: String
    let date: Date
}

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var todayTable: UITableView!
    @IBOutlet weak var yesterdayTable: UITableView!
    var todayData = [Activity]()
    let dateFormatter = DateFormatter()
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        makeActivityRequest()
    }
    let map = [
        1: "Took a shower",
        2: "Went to the park"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        todayTable.dataSource = self
        todayTable.delegate = self
        todayTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        makeActivityRequest()
        
    }
    func makeActivityRequest() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        Alamofire.request("https://mas-care-connect.herokuapp.com/activities/?elderly=1", method: .get).responseJSON { response in
            switch response.result {
            case .success(let result):
                self.todayData.removeAll()
                let json = JSON(result)
                for (_,v) in json {
                    let activityId = v["activityType"].int!
                    let msg = self.map[activityId]! + " for " + v["duration"].string!
                    print(String(v["date"].string!.dropLast()))
                    let date = self.dateFormatter.date(from: String(v["date"].string!.dropLast()))
                    let newActivity = Activity(desc: msg, date: date!)
                    self.todayData.append(newActivity)
                }
                self.todayData.sort(by: { $0.date.compare($1.date) == .orderedDescending})
                print(self.todayData)
                self.todayTable.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return numbber of items
        
        var count:Int?
        
        if tableView == self.todayTable {
            count = todayData.count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == self.todayTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            let previewDetail = todayData[indexPath.row].desc
            cell!.textLabel!.text = previewDetail
            
        }
        return cell!
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
