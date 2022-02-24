//
//  ViewController.swift
//  Pie Chart View
//

import UIKit

class ViewController : UIViewController {

    @IBOutlet private weak var chartView: ChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.listSegment = self.generateData()
        // Update data after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.chartView.listSegment = self.generateData()
        })
    }

    private func generateData() -> [PieChartView.Segment] {
        return [PieChartView.Segment.init(pieColor: UIColor(named: "color_chart_green")!,
                                                               textColor: UIColor(named: "color_chart_text_green")!,
                                                                       value: Double.random(in: 0.5...1),
                                                               title: "元金"),
                PieChartView.Segment.init(pieColor: UIColor(named: "color_chart_yellow")!,
                                                               textColor: UIColor(named: "color_chart_text_orange")!,
                                                                            value: Double.random(in: 0.5...1),
                                                               title: "管理費/\n修繕積立費"),
                PieChartView.Segment.init(pieColor: UIColor(named: "color_chart_red")!,
                                                               textColor: UIColor(named: "color_chart_text_red")!,
                                                                            value: Double.random(in: 0.3...1),
                                                               title: "金利")]
    }
}
