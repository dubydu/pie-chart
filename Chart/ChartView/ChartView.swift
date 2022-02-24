//
//  ChartView.swift
//  Chart
//

import UIKit

class ChartView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var pieChartView: PieChartView!
    @IBOutlet private weak var pieChartSumLabel: UILabel!
    @IBOutlet private var valueLabels: [UILabel]!

    var listSegment: [PieChartView.Segment] = [] {
        didSet {
            setupUI()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    // MARK: - Private Method
    private func initView() {
        Bundle.main.loadNibNamed("ChartView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }

    private func setupUI() {
        pieChartView.segments = listSegment
        pieChartSumLabel.text = "\(Double(round(100 * pieChartView.totalValue) / 100))"
        for (label, segment) in zip(valueLabels, listSegment) {
            label.text = "\(Double(round(100 * segment.value) / 100))万円 / 月"
        }
    }
}
