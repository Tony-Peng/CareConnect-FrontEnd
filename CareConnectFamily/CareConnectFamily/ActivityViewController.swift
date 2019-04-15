//
//  ViewController.swift
//  tables
//
//  Created by Andre on 3/24/19.
//  Copyright © 2019 Andre. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



struct ActivityList {
    let dateString: String
    let data: [ActivityType]
}

struct ActivityType {
    let date: Date
    let dateString: String
    let image: UIImage
    let label: String
}

class ActivityViewController: UITableViewController {
    
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    var cells:[CustomTableViewCell] = []
    var activityIdToNameMap : [Int: String] = [:]
    var activityIdToImageMap : [Int: UIImage] = [:]
    var dateToActivitiesMap : [Date : [ActivityType]] = [:]
    var activityListData: [ActivityList] = []
    
    @IBOutlet weak var surveyButton: UIBarButtonItem!
    
    @IBAction func surveyAction(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SvC = Storyboard.instantiateViewController(withIdentifier: "SurveyActivityViewController") as! SurveyActivityViewController
        self.navigationController?.pushViewController(SvC, animated: true)
    }
    
    @objc func mapActivityTypesFromJSON(data: Any) {
        self.activityIdToNameMap.removeAll()
        self.activityIdToImageMap.removeAll()
        for (_, v) in JSON(data) {
            let id = v["id"].int!
            let imageName = v["name"].string!
            self.activityIdToNameMap[id] = v["description"].string!
            self.activityIdToImageMap[id] = UIImage(named: imageName)!
        }
    }
    
    @objc func createActivity(json: Any) -> Any {
        let data = JSON(json)
        let id = data["activityType"].int!
        let label = self.activityIdToNameMap[id]!
        let image = self.activityIdToImageMap[id]
        let date = self.dateFormatter.date(from: String(data["date"].string!.prefix(19)))
        let dateString = self.dateFormatter2.string(from: date!)
        let newDate = self.dateFormatter2.date(from: dateString)!
        return ActivityType(date: newDate, dateString: dateString, image: image!, label: label)
    }
    
    @objc func getActivityData() {
        Alamofire.request("https://mas-care-connect.herokuapp.com/activities/?elderly=1", method: .get).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                self.dateToActivitiesMap.removeAll()
                self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                self.dateFormatter2.dateFormat = "yyyy-MM-dd"
                for (_,v) in json {
                    let tempActivity = self.createActivity(json: v) as! ActivityType
                    var arr = self.dateToActivitiesMap[tempActivity.date] ?? []
                    arr.insert(tempActivity, at:0)
                    self.dateToActivitiesMap[tempActivity.date] = arr
                }
                var allDates = Array(self.dateToActivitiesMap.keys)
                allDates.sort(by: {$0.compare($1) == .orderedDescending })
                self.activityListData.removeAll()
                for currDate in allDates {
                    self.activityListData.append(ActivityList(dateString: currDate.asString(style: .full), data: self.dateToActivitiesMap[currDate]!))
                }

                for i in 0..<self.cells.count {
                    self.cells[i].data = self.activityListData[i]
                    self.cells[i].tableView.reloadData()
                }
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            case .failure(let error):
                print(error)
            }
            
            
        }
    }
    @objc func reloadData() {
        Alamofire.request("https://mas-care-connect.herokuapp.com/activitytypes", method: .get).responseJSON { response in
            switch response.result {
            case .success(let result):
                self.mapActivityTypesFromJSON(data: result)
                self.getActivityData()
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.title = "Activity Log"
        reloadData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(reloadData), for: .valueChanged)
        self.refreshControl = refreshControl
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! CustomTableViewCell
        cell1.data = activityListData[indexPath.row]
        cell1.tableView.reloadData()
        if(!cells.contains(cell1)) {
            self.cells.append(cell1)
        }
        return cell1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityListData.count
    }
    
}
extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}


class ActivityCell: UITableViewCell {
    
    var activityType : ActivityType? {
        didSet {
            activityLabel.text = activityType?.label
            activityIcon.image = activityType?.image
            activityIcon.frame = CGRect(x: 0, y:0, width: 50, height: 50)
            
        }
    }
    
    var activityLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 55, y: 12, width: 200, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "activity label"
        label.textColor = .black
        return label
        
    }()
    
    private let activityIcon : UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName:"dinner"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(activityIcon)
        addSubview(activityLabel)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    var data = ActivityList(dateString: "loading", data: [])
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
        tableView.register(ActivityCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActivityCell
        title.text = data.dateString
        cell.activityType = data.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10))
    }
}

