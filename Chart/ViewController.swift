//
//  ViewController.swift
//  Pie Chart View
//

import UIKit

class ViewController : UIViewController {

    @IBOutlet private weak var chartView: ChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.listSegment = [Segment.init(pieColor: UIColor(named: "color_chart_green")!,
                                              textColor: UIColor(named: "color_chart_text_green")!,
                                              value: 0.8,
                                              title: "元金"),
                                 Segment.init(pieColor: UIColor(named: "color_chart_yellow")!,
                                              textColor: UIColor(named: "color_chart_text_orange")!,
                                              value: 0.4,
                                              title: "管理費/\n修繕積立費"),
                                 Segment.init(pieColor: UIColor(named: "color_chart_red")!,
                                              textColor: UIColor(named: "color_chart_text_red")!,
                                              value: 0.2,
                                              title: "金利")]
    }
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
