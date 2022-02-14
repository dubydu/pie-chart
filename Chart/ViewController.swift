//
//  ViewController.swift
//  Pie Chart View
//

import UIKit

struct Segment {
    var pieColor: UIColor
    var textColor: UIColor
    var value: CGFloat
    var title: String
}

class PieChartView: UIView {

    var segments = [Segment]() {
        didSet {
            totalValue = segments.reduce(0) { $0 + $1.value }
            setupLabels()
            setNeedsDisplay()
            layoutLabels()
        }
    }

    var totalValue: CGFloat = 1
    private var labels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        let anglePI2 = (CGFloat.pi * 2)
        let center = CGPoint.init(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = min(bounds.size.width, bounds.size.height) / 2

        let lineWidth: CGFloat = 5

        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(lineWidth)

        var currentAngle: CGFloat = -(CGFloat.pi / 2)

        if totalValue <= 0 {
            totalValue = 1
        }

        let iRange = 0 ..< segments.count
        for i in iRange {
            let segment = segments[i]
            let percent = segment.value / totalValue
            print(segment)

            let angle = anglePI2 * percent

          print("-- \(angle)")

            ctx?.beginPath()
            ctx?.move(to: center)
            ctx?.addArc(center: center, radius: radius - lineWidth, startAngle: currentAngle, endAngle: currentAngle + angle, clockwise: false)
            ctx?.closePath()

            ctx?.setFillColor(segment.pieColor.cgColor)
            ctx?.fillPath()

            ctx?.beginPath()
            ctx?.move(to: center)
            ctx?.addArc(center: center, radius: radius - (lineWidth / 2), startAngle: currentAngle, endAngle: currentAngle + angle, clockwise: false)
            ctx?.closePath()

            ctx?.setStrokeColor(UIColor.systemBackground.cgColor)
            ctx?.strokePath()

            currentAngle += angle
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutLabels()
    }

    private func setupLabels() {
        var diff = segments.count - labels.count
        if diff >= 0 {
            for _ in 0 ..< diff {
                let lbl = UILabel()
                self.addSubview(lbl)
                labels.append(lbl)
            }
        } else {
            while diff != 0 {
                var lbl: UILabel!
                if labels.count <= 0 {
                    break
                }
                lbl = labels.removeLast()
                if lbl.superview != nil {
                    lbl.removeFromSuperview()
                }
                diff += 1
            }
        }

        for (lbl, segment) in zip(labels, segments) {
          let titleFont = UIFont(name: "HiraginoSans-W6", size: 13)
          let valueFont = UIFont(name: "HiraginoSans-W6", size: 16)
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.lineSpacing = 4
          paragraphStyle.alignment = .center

          let attributesTitle: [NSAttributedString.Key: Any] = [
              .font: titleFont,
              .foregroundColor: segment.textColor,
              .paragraphStyle: paragraphStyle
          ]
          let attributesValue: [NSAttributedString.Key: Any] = [
              .font: valueFont,
              .foregroundColor: segment.textColor,
              .paragraphStyle: paragraphStyle
          ]

          let titleMutableAttributed = NSMutableAttributedString(string: segment.title, attributes: attributesTitle)
          let valueAttributed = NSAttributedString(string: "\n\(segment.value)万円", attributes: attributesValue)
          titleMutableAttributed.append(valueAttributed)

          lbl.attributedText = titleMutableAttributed
        }
    }

    func layoutLabels() {
        let anglePI2 = CGFloat.pi * 2
        let center = CGPoint.init(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = (min(bounds.size.width / 2, bounds.size.height / 2) * 1.3)

        var currentAngle: CGFloat = -(CGFloat.pi / 2)

        let iRange = 0 ..< labels.count
        for i in iRange {
            let lbl = labels[i]
            let percent = segments[i].value / totalValue

            let intervalAngle = anglePI2 * percent
            lbl.frame = .zero
            lbl.numberOfLines = 0
            lbl.sizeToFit()

            let x = center.x + (radius * cos(currentAngle + (intervalAngle / 2)))
            let y = center.y + (radius * sin(currentAngle + (intervalAngle / 2)))
            lbl.center = CGPoint.init(x: x, y: y)
            currentAngle += intervalAngle
        }
    }
}

class ViewController : UIViewController {

  @IBOutlet private weak var pieChartView: PieChartView!
  @IBOutlet private weak var pieChartCenterView: UIView!
  @IBOutlet private weak var pieChartSumLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    pieChartView.segments = [
      Segment.init(pieColor: UIColor(named: "color_chart_green")!,
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
                   title: "金利")
    ]
    pieChartSumLabel.text = "\(Double(round(100 * pieChartView.totalValue) / 100))"
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
