//
//  ExamplesDefaults.swift
//  SwiftCharts
//
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//
import UIKit
import SwiftCharts

struct ExamplesDefaults {
    
    static var chartSettings: ChartSettings {
        return iPhoneChartSettings
    }
    
    static var chartSettings2: ChartSettings {
        return iPhoneChartSettings
    }
    
    static var chartSettingsWithPanZoom: ChartSettings {
        return iPhoneChartSettingsWithPanZoom
    }
    
    static var chartSettingsWithPanZoom2: ChartSettings {
        return iPhoneChartSettingsWithPanZoom2
    }
    
    fileprivate static var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettings2: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 0
        chartSettings.top = 0
        chartSettings.trailing = 0
        chartSettings.bottom = 0
        chartSettings.labelsToAxisSpacingX = 0
        chartSettings.labelsToAxisSpacingY = 0
        chartSettings.axisTitleLabelsToLabelsSpacing = 0
        chartSettings.axisStrokeWidth = 0.0
        chartSettings.spacingBetweenAxesX = 0
        chartSettings.spacingBetweenAxesY = 0
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPhoneChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettingsWithPanZoom2: ChartSettings {
        var chartSettings = iPhoneChartSettings2
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    static func chartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 30
            , y: 115, width: 295, height: 105)
    }
    
    static var labelSettings: ChartLabelSettings {
        return ChartLabelSettings(font: ExamplesDefaults.labelFont)
    }
    
    static var labelFont: UIFont {
        return ExamplesDefaults.fontWithSize(11)
    }
    
    static var labelFontSmall: UIFont {
        return ExamplesDefaults.fontWithSize(10)
    }
    
    static func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var guidelinesWidth: CGFloat {
        return 0.1
    }
    
    static var minBarSpacing: CGFloat {
        return 5
    }
}
