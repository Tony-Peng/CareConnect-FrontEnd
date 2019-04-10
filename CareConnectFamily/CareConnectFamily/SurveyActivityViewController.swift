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

class SurveyActivityViewController: UIViewController {
    fileprivate var chart: Chart? // arc
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func chartFrameFunc(xValue: Int, yValue: Int) -> CGRect {
        return CGRect(x: xValue
            , y: yValue, width: 275, height: 275)
    }
    
    func generateBooleanChart(xValue: Int, yValue: Int, yAxisLabel: String, attentiveData: [(date: String, val: Double)], hopeData: [(date: String, val: Double)]) {
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        let zero = ChartAxisValueDouble(0)
        
        let yGenerator = ChartAxisGeneratorMultiplier(1)
        let labelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
            return ChartAxisLabel(text: "\(scalar)", settings: labelSettings)
        }
        
        //Generate Axis Values
        let letterAxisValues = [ChartAxisValueString(order: -1)] +
            attentiveData.enumerated().map {index, tuple in ChartAxisValueString(tuple.0, order: index, labelSettings: labelSettings)} + [ChartAxisValueString(order: attentiveData.count)]
        
        let xModel = ChartAxisModel(axisValues: letterAxisValues, axisTitleLabel: ChartAxisLabel(text: "Past Seven Days", settings: labelSettings))
        let yModel = ChartAxisModel(firstModelValue: 0, lastModelValue: 1, axisTitleLabels: [ChartAxisLabel(text: yAxisLabel, settings: labelSettings.defaultVertical())], axisValuesGenerator: yGenerator, labelsGenerator: labelsGenerator)
        
        let chartFrame = chartFrameFunc(xValue: xValue, yValue: yValue)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        //Choosing Colors
        let alpha: CGFloat = 0.6
        let attentiveColor = UIColorFromRGB(rgbValue: 0x111111).withAlphaComponent(alpha)
        let hopeColor = UIColorFromRGB(rgbValue: 0x4286f4)
        let attentiveLineLayer = self.generateLines(data: attentiveData, coordsSpace: coordsSpace, color: attentiveColor)
        let hopeLineLayer = self.generateLines(data: hopeData, coordsSpace: coordsSpace, color: hopeColor)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                attentiveLineLayer,
                hopeLineLayer
            ]
        )
        
        self.view.addSubview(chart.view)
        self.chart = chart
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
    var attentiveResponse = [(date: String, val: Int)]()
    var hopeResponse = [(date: String, val: Int)]()
    let dateFormatter = DateFormatter()
    let dateFormatterString = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatTitle(label: self.trendLabel)

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

                }
                let attentiveData = self.movingAverage(input: self.attentiveResponse.prefix(7))
                let hopeData = self.movingAverage(input: self.hopeResponse.prefix(7))
                self.generateBooleanChart(xValue: 35, yValue: Int(self.trendLabel.center.y + 4), yAxisLabel: "Attentiveness", attentiveData: attentiveData, hopeData: hopeData)
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
            print(runningAvg, currTotal)
            let newAvg = Double(runningAvg) / Double(currTotal)
            ans.append((date: k, val: newAvg))
        }
        print(ans)
        return ans
    }
}
