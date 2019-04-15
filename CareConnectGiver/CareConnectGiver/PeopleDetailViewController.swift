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
import SwiftCharts

class PeopleDetailViewController: UIViewController {
    
    var person: Person?
    fileprivate var barChart: Chart?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    
    var moodResponse = [(date: String, val: Int)]()
    let dateFormatter = DateFormatter()
    let dateFormatterString = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = self.person?.name
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        moodLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.loadProfilePicture()
        //Grab the survey result from API
        let url = "https://mas-care-connect.herokuapp.com/quizresponses/?elderly=" + String(person!.id)
        Alamofire.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let result):
                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                self.dateFormatterString.dateFormat = "M/d"
                let json = JSON(result)
                for(_,v) in json {
                    let date = self.dateFormatter.date(from: String(v["date"].string!.prefix(10)))
                    let dateString = self.dateFormatterString.string(from: date!)
                    self.moodResponse.append((date: dateString, val: v["q8_mood"].int!))
                }
                
                let moodData = self.countMood(input: self.moodResponse.prefix(7))
                self.generateImageBarChart(xValue: 50, yValue: 260, moodData: moodData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func generateImageBarChart(xValue: Int, yValue: Int, moodData: [(mood: String, value: Int)]) {
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.fontWithSize(0))
        let moodAxisValues = [ChartAxisValueString(order: -1)] +
            moodData.enumerated().map {index, tuple in ChartAxisValueString(String(tuple.0), order: index, labelSettings: labelSettings)} + [ChartAxisValueString(order: moodData.count)]
        
        let valueAxisValues = [ChartAxisValueString(order: -1)] +
            moodData.enumerated().map {index, tuple in ChartAxisValueString(String(tuple.1), order: index, labelSettings: labelSettings)} + [ChartAxisValueString(order: moodData.count)]
        
        let xModel = ChartAxisModel(axisValues: valueAxisValues, axisTitleLabel: ChartAxisLabel(text: "Value", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: moodAxisValues, axisTitleLabel: ChartAxisLabel(text: "Mood", settings: labelSettings.defaultVertical()))
        let chartFrame = CGRect(x: xValue
            , y: yValue, width: 340, height: 240)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom2
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        let barViewSettings = ChartBarViewSettings(animDuration: 0.5)
        let zero = ChartAxisValueDouble(0)
        let bars: [ChartBarModel] = moodData.enumerated().flatMap {tuple in
            [
                ChartBarModel(constant: ChartAxisValueDouble(tuple.offset), axisValue1: zero, axisValue2: ChartAxisValueDouble(tuple.element.value), bgColor: UIColor(
                    red: CGFloat(0.0/255.0),
                    green: CGFloat(122.0/255.0),
                    blue: CGFloat(255.0/255.0),
                    alpha: CGFloat(0.8)
                ))
            ]
        }
        let barsLayer = ChartBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, bars: bars, horizontal: true, barWidth: 20
            , settings: barViewSettings)
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                barsLayer
            ]
        )
        self.view.addSubview(chart.view)
        self.barChart = chart
    }
    
    func countMood(input : ArraySlice<(date: String, val: Int)>)  -> [(mood: String, value: Int)]{
        print(input)
        var counts = [
            0 : 0,
            1 : 0, // Always use optional values carefully!
            2 : 0,
            3 : 0,
            4 : 0
        ]
        for (_,v) in input {
            counts.updateValue(counts[Int(v)]! + 1, forKey: Int(v))
        }
        var returnArray = [(mood: String, value: Int)]()
        for (k,v) in counts {
            returnArray.append((mood: String(k), value: v))
        }
        returnArray.sort() { $0.0 < $1.0 }
        return returnArray
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
