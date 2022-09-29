//
//  CircleView.swift
//  Imairu
//
//  Created by Matsunaka Shigeki on 2022/09/29.
//

import UIKit

class CircleView: UIView {
    var fillColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    var borderWidth: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var borderColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    var circleCenter: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    var radius: CGFloat = 0 {
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
        let circle = UIBezierPath(
            arcCenter: circleCenter,
            radius: radius - borderWidth/2,
            startAngle: 0,
            endAngle: CGFloat(Double.pi)*2,
            clockwise: true
        )

        fillColor.setFill()
        circle.fill()
        borderColor.setStroke()
        circle.lineWidth = borderWidth
        circle.stroke()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self && point.distance(from: circleCenter) > radius {
            return nil
        }
        return view
    }
}

private extension CGPoint {
    func distance(from point: CGPoint) -> Double {
        sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y))
    }
}
