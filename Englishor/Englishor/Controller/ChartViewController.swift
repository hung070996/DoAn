//
//  ChartViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/17/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SwiftCharts

class ChartViewController: UIViewController {
    
    fileprivate var chart: Chart?
    @IBOutlet weak var viewChart: UIView!
    @IBOutlet weak var navigationView: NavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.setHiddenView(nextLv: true, title: false, back: false)
        navigationView.setTitle(title: "Analytic")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yyyy"
        let month = formatter.string(from: Date())
        
        var line1 = [(Int, Int)]()
        var line2 = [(Int, Int)]()
        var line3 = [(Int, Int)]()
        var line4 = [(Int, Int)]()
        var line5 = [(Int, Int)]()
        
        let data  = Utils.shared.getDataAnalytic()
        for phase in data {
            if let date = phase.date {
                if date.hasSuffix(month) {
                    let day = String(date.prefix(2))
                    line1.append((Int(day) ?? 0, phase.pointLv1 ?? 0))
                    line2.append((Int(day) ?? 0, phase.pointLv2 ?? 0))
                    line3.append((Int(day) ?? 0, phase.pointLv3 ?? 0))
                    line4.append((Int(day) ?? 0, phase.pointLv4 ?? 0))
                    line5.append((Int(day) ?? 0, phase.pointLv5 ?? 0))
                }
            }
            
        }
        
        let labelSettings = ChartLabelSettings(font: Utils.shared.globalFont)
        
        let chartPoints = [(0,0),(0,20),(0,40),(0,60),(0,80),(0,100)].map { ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
        
        let chartPoints1 = line1.map { ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
        
        let chartPoints2 = line2.map { ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
        
        let chartPoints3 = line3.map { ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
        
        let chartPoints4 = line4.map { ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
        
        let chartPoints5 = line5.map { ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
        
        let xValues = chartPoints1.map { $0.x }
        
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 0, maxSegmentCount: 100, multiple: 20, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Day", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Point", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(viewChart.bounds)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor.red, animDuration: 1, animDelay: 0)
        let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: UIColor.blue, animDuration: 1, animDelay: 0)
        let lineModel3 = ChartLineModel(chartPoints: chartPoints3, lineColor: UIColor.black, animDuration: 1, animDelay: 0)
        let lineModel4 = ChartLineModel(chartPoints: chartPoints4, lineColor: UIColor.green, animDuration: 1, animDelay: 0)
        let lineModel5 = ChartLineModel(chartPoints: chartPoints5, lineColor: UIColor.yellow, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel1, lineModel2, lineModel3, lineModel4, lineModel5], useView: false)
        
        let thumbSettings = ChartPointsLineTrackerLayerThumbSettings(thumbSize: 10, thumbBorderWidth: 10)
        let trackerLayerSettings = ChartPointsLineTrackerLayerSettings(thumbSettings: thumbSettings)
        
        var currentPositionLabels: [UILabel] = []
        
        let chartPointsTrackerLayer = ChartPointsLineTrackerLayer<ChartPoint, Any>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lines: [chartPoints1, chartPoints2, chartPoints3, chartPoints4, chartPoints5], lineColor: UIColor.black, animDuration: 1, animDelay: 2, settings: trackerLayerSettings) {chartPointsWithScreenLoc in
            
            currentPositionLabels.forEach{$0.removeFromSuperview()}
            
            for (index, chartPointWithScreenLoc) in chartPointsWithScreenLoc.enumerated() {
                
                let label = UILabel()
                label.text = chartPointWithScreenLoc.chartPoint.description
                label.sizeToFit()
                label.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x + label.frame.width / 2, y: chartPointWithScreenLoc.screenLoc.y + chartFrame.minY - label.frame.height / 2)
                
                label.backgroundColor = index == 0 ? UIColor.red : UIColor.blue
                label.textColor = UIColor.white
                
                currentPositionLabels.append(label)
                self.view.addSubview(label)
            }
        }
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer,
                chartPointsTrackerLayer
            ]
        )
        
        viewChart.addSubview(chart.view)
        self.chart = chart
    }
}
