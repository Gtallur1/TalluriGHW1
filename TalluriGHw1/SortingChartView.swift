//
//  SortingChartView.swift
//  TalluriGHw1
//
//  Created by Gayatri Talluri on 4/17/25.
//
import UIKit

class SortingChartView: UIView {
    
    // Properties
    private var array: [Int] = []
    private var maxValue: Int = 100
    private var barColor: UIColor = .systemGreen
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 8
    }
    
    // Public Methods
    func setArray(_ newArray: [Int], barColor: UIColor = .systemGreen) {
        self.array = newArray
        self.maxValue = newArray.max() ?? 100
        self.barColor = barColor
        setNeedsDisplay()
    }
    
    func updateArray(_ newArray: [Int], barColor: UIColor? = nil) {
        self.array = newArray
        if let color = barColor {
            self.barColor = color
        }
        setNeedsDisplay()
    }
    
    func getArray() -> [Int]? {
        return array
    }
    
    //Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext(), !array.isEmpty else { return }
        
        let barCount = array.count
        let barWidth = rect.width / CGFloat(barCount)
        let maxHeight = rect.height - 10// top space
        
        // to Draw each bar
        for (index, value) in array.enumerated() {
            let barHeight = (CGFloat(value) / CGFloat(maxValue)) * maxHeight
            let barRect = CGRect(
                x: CGFloat(index) * barWidth,
                y: rect.height - barHeight,
                width: barWidth - 2,//gap between bars
                height: barHeight
            )
            
            barColor.setFill()
            context.fill(barRect)
        }
    }
}
