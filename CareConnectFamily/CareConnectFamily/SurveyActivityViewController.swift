//
//  SurveyActivityViewController.swift
//  CareConnectFamily
//
//  Created by Michael Chen on 4/2/19.
//  Copyright © 2019 Michael Chen. All rights reserved.
//

import UIKit
import SwiftCharts
import Alamofire
import SwiftyJSON
import ChartLegends

class SurveyActivityViewController: UIViewController, ChartLegendsDelegate {
    fileprivate var lineChart: Chart?
    fileprivate var barChart: Chart?
    fileprivate var legend: ChartLegendsView?

    let colors = [
        "Attentiveness": UIColor(
        red: CGFloat(230.0/255.0),
        green: CGFloat(25.0/255.0),
        blue: CGFloat(75.0/255.0),
        alpha: CGFloat(1.0)
        ),
        "Hope" : UIColor(
            red: CGFloat(60.0/255.0),
            green: CGFloat(180.0/255.0),
            blue: CGFloat(75.0/255.0),
            alpha: CGFloat(1.0)
        ),
        "Empathy" : UIColor(
            red: CGFloat(0.0/255.0),
            green: CGFloat(130.0/255.0),
            blue: CGFloat(200.0/255.0),
            alpha: CGFloat(1.0)
        ),
        "Humor" : UIColor(
            red: CGFloat(245.0/255.0),
            green: CGFloat(130.0/255.0),
            blue: CGFloat(48.0/255.0),
            alpha: CGFloat(1.0)
        ),
        "Anxiety" : UIColor(
            red: CGFloat(145.0/255.0),
            green: CGFloat(30.0/255.0),
            blue: CGFloat(180.0/255.0),
            alpha: CGFloat(1.0)
        ),
        "Sleep" : UIColor(
            red: CGFloat(0.0/255.0),
            green: CGFloat(0.0/255.0),
            blue: CGFloat(0.0/255.0),
            alpha: CGFloat(1.0)
        ),
        "Appetite" : UIColor(
            red: CGFloat(170.0/255.0),
            green: CGFloat(110.0/255.0),
            blue: CGFloat(40.0/255.0),
            alpha: CGFloat(1.0)
        )
    ]
    
    func chartFrameFunc(xValue: Int, yValue: Int) -> CGRect {
        return CGRect(x: xValue
            , y: yValue, width: 300, height: 275)
    }
    
    func generateBooleanChart(xValue: Int, yValue: Int, yAxisLabel: String, attentiveData: [(date: String, val: Double)], hopeData: [(date: String, val: Double)], empathyData: [(date: String, val: Double)], humorData: [(date: String, val: Double)]) {
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        //Generate Axis Values
        let letterAxisValues = [ChartAxisValueString(order: -1)] +
            attentiveData.enumerated().map {index, tuple in ChartAxisValueString(tuple.0, order: index, labelSettings: labelSettings)} + [ChartAxisValueString(order: attentiveData.count)]
        let trendValues = [ChartAxisValueString("Low", order: 0, labelSettings: labelSettings), ChartAxisValueString("High", order: 1, labelSettings: labelSettings)]
        
        let xModel = ChartAxisModel(axisValues: letterAxisValues, axisTitleLabel: ChartAxisLabel(text: "Past Seven Days", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: trendValues, axisTitleLabel: ChartAxisLabel(text: "Value", settings: labelSettings.defaultVertical()))
        
        let chartFrame = chartFrameFunc(xValue: xValue, yValue: yValue)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let attentiveLineLayer = self.generateLines(data: attentiveData, coordsSpace: coordsSpace, color: colors["Attentiveness"]!)
        let hopeLineLayer = self.generateLines(data: hopeData, coordsSpace: coordsSpace, color: colors["Hope"]!)
        let empathyLineLayer = self.generateLines(data: empathyData, coordsSpace: coordsSpace, color: colors["Empathy"]!)
        let humorLineLayer = self.generateLines(data: humorData, coordsSpace: coordsSpace, color: colors["Humor"]!)
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                attentiveLineLayer,
                hopeLineLayer,
                empathyLineLayer,
                humorLineLayer
            ]
        )
        let legends = [
            (text: "Attentive", color: colors["Attentiveness"]!),
            (text: "Hope", color: colors["Hope"]!),
            (text: "Empathy", color: colors["Empathy"]!),
            (text: "Humor", color: colors["Humor"]!),
            (text: "Anxiety", color: colors["Anxiety"]!),
            (text: "Sleep", color: colors["Sleep"]!),
            (text: "Appetite", color: colors["Appetite"]!)
        ]
        legendOutlet.setLegends(legends)

        self.view.addSubview(chart.view)
        self.lineChart = chart
        legendOutlet.delegate = self
    }
    
    func generateImageBarChart(xValue: Int, yValue: Int, moodData: [(mood: String, value: Int)]) {
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.fontWithSize(0))
        let moodAxisValues = [ChartAxisValueString(order: -1)] +
            moodData.enumerated().map {index, tuple in ChartAxisValueString(String(tuple.0), order: index, labelSettings: labelSettings)} + [ChartAxisValueString(order: moodData.count)]
        
        let valueAxisValues = [ChartAxisValueString(order: -1)] +
            moodData.enumerated().map {index, tuple in ChartAxisValueString(String(tuple.1), order: index, labelSettings: labelSettings)} + [ChartAxisValueString(order: moodData.count)]
        print(moodAxisValues)
        print(valueAxisValues)
        
        let xModel = ChartAxisModel(axisValues: valueAxisValues, axisTitleLabel: ChartAxisLabel(text: "Value", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: moodAxisValues, axisTitleLabel: ChartAxisLabel(text: "Mood", settings: labelSettings.defaultVertical()))
        let chartFrame = CGRect(x: xValue
            , y: yValue, width: 340, height: 275)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom2
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        let barViewSettings = ChartBarViewSettings(animDuration: 0.5)
        let zero = ChartAxisValueDouble(0)
        print(moodData)
        let bars: [ChartBarModel] = moodData.enumerated().flatMap {tuple in
            [
                ChartBarModel(constant: ChartAxisValueDouble(tuple.offset), axisValue1: zero, axisValue2: ChartAxisValueDouble(tuple.element.value), bgColor: UIColor.gray)
            ]
        }
        let barsLayer = ChartBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, bars: bars, horizontal: true, barWidth: 30, settings: barViewSettings)
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
    
    func generateLines(data: [(date: String, val: Double)], coordsSpace : ChartCoordsSpaceLeftBottomSingleAxis, color: UIColor) -> ChartPointsLineLayer<ChartPoint> {
        // line layer
        let (xAxisLayer, yAxisLayer) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer)
        let lineChartPoints = data.enumerated().map {index, tuple in ChartPoint(x: ChartAxisValueDouble(index), y: ChartAxisValueDouble(tuple.val))}
        let lineModel = ChartLineModel(chartPoints: lineChartPoints, lineColor: color, lineWidth: 2, animDuration: 0.5, animDelay: 1)
        let newLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
        
        return newLineLayer
    }
    
    
    @IBOutlet weak var trendLabel: UILabel!
    @IBOutlet weak var moodResultLabel: UILabel!
    @IBOutlet weak var legendOutlet: ChartLegendsView!
    
    var attentiveResponse = [(date: String, val: Int)]()
    var hopeResponse = [(date: String, val: Int)]()
    var empathyResponse = [(date: String, val: Int)]()
    var humorResponse = [(date: String, val: Int)]()
    var moodResponse = [(date: String, val: Int)]()
    let dateFormatter = DateFormatter()
    let dateFormatterString = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatTitle(label: self.trendLabel)
        self.formatTitle(label: self.moodResultLabel)

        //Grab the survey result from API
        Alamofire.request("https://mas-care-connect.herokuapp.com/quizresponses/?elderly=1", method: .get).responseJSON { response in
            switch response.result {
            case .success(let result):
                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                self.dateFormatterString.dateFormat = "M/d"
                let json = JSON(result)
                for(_,v) in json {
                    let date = self.dateFormatter.date(from: String(v["date"].string!.prefix(10)))
                    let dateString = self.dateFormatterString.string(from: date!)
                    self.attentiveResponse.append((date: dateString, val: v["q1_attentive"].int!))
                    self.hopeResponse.append((date: dateString, val: v["q2_hope"].int!))
                    self.empathyResponse.append((date: dateString, val: v["q3_empathetic"].int!))
                    self.humorResponse.append((date: dateString, val: v["q4_humor"].int!))
                    self.moodResponse.append((date: dateString, val: v["q8_mood"].int!))
                }
                let attentiveData = self.movingAverage(input: self.attentiveResponse.prefix(7))
                let hopeData = self.movingAverage(input: self.hopeResponse.prefix(7))
                let empathyData = self.movingAverage(input: self.empathyResponse.prefix(7))
                let humorData = self.movingAverage(input: self.humorResponse.prefix(7))
                self.generateBooleanChart(xValue: 0, yValue: Int(self.trendLabel.center.y + 4), yAxisLabel: "Value", attentiveData: attentiveData, hopeData: hopeData, empathyData : empathyData, humorData: humorData)

                let moodData = self.countMood(input: self.moodResponse.prefix(7))
                self.generateImageBarChart(xValue: 42, yValue: 475, moodData: moodData)
            case .failure(let error):
                print(error)
            }
        }
    }
    func formatTitle(label: UILabel) {
        label.center.x = self.view.center.x
        label.font = UIFont.boldSystemFont(ofSize: 16)
    }

    func movingAverage(input : ArraySlice<(date: String, val: Int)>) -> [(date: String, val: Double)] {
        let reversedInput = input.reversed()
        var ans = [(date: String, val: Double)]()
        var runningAvg = 0
        var currTotal = 0
        for (k, v) in reversedInput {
            runningAvg += v
            currTotal += 1
            let newAvg = Double(runningAvg) / Double(currTotal)
            ans.append((date: k, val: newAvg))
        }
        return ans
    }
    
    func countMood(input : ArraySlice<(date: String, val: Int)>)  -> [(mood: String, value: Int)]{
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
    
    func onSelectLegend(legend: ChartLegend, cell: UICollectionViewCell, indexPath: IndexPath) {
        print("Selected legend: \(legend.text)")
    }
}

