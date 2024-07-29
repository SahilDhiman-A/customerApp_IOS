//
//  DataUsageGraphClass.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/23/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import Charts


extension UIViewController
{
    // This function used for set Data Usage Graph
    func setChart(_ lineChartView: LineChartView, numberOfDayOrMonth: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<values.count
        {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:numberOfDayOrMonth)
        lineChartView.xAxis.granularity = 1
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "First Set")
        lineChartDataSet.setColor(UIColor.cornerBGFullOpack)
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawCirclesEnabled = true
        lineChartDataSet.lineWidth = 2.0
        lineChartDataSet.setCircleColor(UIColor.cornerBGFullOpack)
        lineChartDataSet.circleRadius = 5.0
        lineChartDataSet.highlightColor = UIColor.clear
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = true
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartDataSet.drawValuesEnabled = false
        var dataSets = [IChartDataSet]()
        dataSets.append(lineChartDataSet)
        let lineChartData = LineChartData(dataSets: dataSets)
        lineChartView.data = lineChartData
    }
}
