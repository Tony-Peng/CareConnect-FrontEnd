//
//  ViewController.swift
//  tables
//
//  Created by Lauren Kearley on 3/24/19.
//  Copyright © 2019 vip.btap. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Activity {
    let date: String
    let desc: [String]
}

class ActivityViewController: UITableViewController {
    
    var todayData : [Date : [String]] = [:]
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    var activity : [Activity] = []
    
    @IBAction func refreshAction(_ sender: Any) {
        makeActivityRequest()
    }
    var map : [Int: String] = [:]
    
    func makeActivityRequest() {
        Alamofire.request("https://mas-care-connect.herokuapp.com/activitytypes", method: .get).responseJSON { response in
            switch response.result {
            case .success(let result):
                self.map.removeAll()
                let json = JSON(result)
                for (_,v) in json {
                    let id = v["id"].int!
                    let desc = v["description"].string!
                    self.map[id] = desc
                }
                self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                self.dateFormatter2.dateFormat = "yyyy-MM-dd"
                Alamofire.request("https://mas-care-connect.herokuapp.com/activities/?elderly=1", method: .get).responseJSON { response in
                    switch response.result {
                    case .success(let result):
                        self.todayData.removeAll()
                        let json = JSON(result)
                        for (_,v) in json {
                            let activityId = v["activityType"].int!
                            let msg = self.map[activityId]!
                            let date = self.dateFormatter.date(from: String(v["date"].string!.prefix(19)))
                            let dateString = self.dateFormatter2.string(from: date!)
                            let newDate = self.dateFormatter2.date(from: dateString)
                            var arr = self.todayData[newDate!] ?? []
                            arr.append(msg)
                            self.todayData[newDate!] = arr
                        }
                        var allDates = Array(self.todayData.keys)
                        allDates.sort(by: {$0.compare($1) == .orderedDescending })
                        for key in allDates {
                            self.activity.append(Activity(date: self.dateFormatter2.string(from: key), desc: self.todayData[key]!))
                        }
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.title = "Welcome Michael!"
        makeActivityRequest()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! CustomTableViewCell
        cell1.data = activity[indexPath.row]
        return cell1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.count
    }
    
}
class CustomTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    var data = Activity(date: "loading", desc: [])
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var title: UILabel!
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.boldSystemFont(ofSize: 20)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView()
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.desc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cells")
        title.text = data.date
        cell.textLabel?.text = data.desc[indexPath.row]
        return cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10))
    }
}

