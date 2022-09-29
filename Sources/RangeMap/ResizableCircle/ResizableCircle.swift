//
//  ResizableCircle.swift
//
//  Created by Matsunaka Shigeki on 2022/09/27.
//

import UIKit

class ResizableCircle: UIView {
    private let thumb: CircleView = .init()
    private let circle: CircleView = .init()
    private let line: LabelledDottedLine = .init()
    
    weak var delegate: ResizableCircleDelegate? = nil
    
    var radius: CGFloat = 0 {
        didSet {
            moveThumb()
            scaleCircle()
            resizeLine()
        }
    }
    
    var circleCenter: CGPoint = .zero {
        didSet {
            moveThumb()
            scaleCircle()
            resizeLine()
        }
    }
    
    // Thumb
    var thumbRadius: CGFloat = 12 {
        didSet {
            thumb.radius = thumbRadius
        }
    }
    
    var thumbColor: UIColor = .init(red: 40/256, green: 124/256, blue: 255/256, alpha: 1) {
        didSet {
            thumb.fillColor = thumbColor
        }
    }
    
    // Circle
    var circleColor: UIColor = .init(red: 40/256, green: 124/256, blue: 255/256, alpha: 0.2) {
        didSet {
            circle.fillColor = circleColor
        }
    }
    
    var borderWidth: CGFloat = 3 {
        didSet {
            circle.borderWidth = borderWidth
        }
    }
    
    var borderColor: UIColor = .init(red: 40/256, green: 124/256, blue: 255/256, alpha: 1) {
        didSet {
            circle.borderColor = borderColor
        }
    }
    
    // Line
    var lineColor: UIColor = .init(red: 40/256, green: 124/256, blue: 255/256, alpha: 1) {
        didSet {
            line.color = lineColor
        }
    }
    
    var label: String = "" {
        didSet {
            line.label = label
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        circle.frame = frame
        thumb.frame = frame
        line.frame = frame
        circle.setNeedsDisplay()
        thumb.setNeedsDisplay()
        line.setNeedsDisplay()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }
    
    private func commonInit() {
        // circle
        circle.circleCenter = circleCenter
        circle.radius = radius
        circle.fillColor = circleColor
        circle.borderWidth = borderWidth
        circle.borderColor = borderColor
        circle.isUserInteractionEnabled = false
        addSubview(circle)
        
        // line
        line.startPoint = circleCenter
        line.endPoint = .init(x: circleCenter.x + radius, y: circleCenter.y)
        line.color = lineColor
        line.label = label
        line.isUserInteractionEnabled = false
        addSubview(line)
        
        // thumb
        thumb.radius = thumbRadius
        thumb.circleCenter = .init(x: circleCenter.x + radius, y: circleCenter.y)
        thumb.fillColor = thumbColor
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panAction(_:)))
        thumb.addGestureRecognizer(panGesture)
        addSubview(thumb)
    }
}

// MARK: - Thumb
private extension ResizableCircle {
    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        radius = max(circleCenter.x, gesture.location(in: self).x) - circleCenter.x
        delegate?.resizableCircleDidChangeRadius(self)
        
        if gesture.state == .ended {
            delegate?.resizableCircleDidEndChangingRadius(self)
        }
    }
    
    func moveThumb() {
        thumb.circleCenter = .init(x: circleCenter.x + radius, y: circleCenter.y)
    }
}
    
// MARK: - Circle
private extension ResizableCircle {
    func scaleCircle() {
        circle.circleCenter = circleCenter
        circle.radius = radius
        circle.setNeedsDisplay()
    }
}

// MARK: - Line
private extension ResizableCircle {
    func resizeLine() {
        line.startPoint = circleCenter
        line.endPoint = .init(x: circleCenter.x + radius, y: circleCenter.y)
        line.setNeedsDisplay()
    }
}
