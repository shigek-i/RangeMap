//
//  LabelledDottedLine.swift
//  Imairu
//
//  Created by Matsunaka Shigeki on 2022/09/29.
//

import UIKit

class LabelledDottedLine: UIView {
    var label: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var radius: CGFloat = 4 {
        didSet {
            setNeedsDisplay()
        }
    }
    var startPoint: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    var endPoint: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    var color: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        // Line
        let line = UIBezierPath()
        
        line.lineWidth = radius
        line.move(to: startPoint)
        line.addLine(to: endPoint)
        
        line.setLineDash([0, radius*2], count: 2, phase: 0)
        line.lineCapStyle = .round
        
        color.setStroke()
        
        line.stroke()
        
        // label
        let attributedLabel: NSAttributedString = .init(
            string: label,
            attributes: [
                .foregroundColor: color,
                .font: UIFont.systemFont(ofSize: 11, weight: .bold)
            ]
        )
        let labelPosition: CGPoint = .init(
            x: (startPoint.x + endPoint.x)/2 - attributedLabel.size().width/2,
            y: (startPoint.y + endPoint.y)/2 - attributedLabel.size().height - 5
        )
        attributedLabel.draw(at: labelPosition)
    }
}
