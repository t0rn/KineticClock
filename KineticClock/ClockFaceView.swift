//
//  ClockFaceView.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 07.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import UIKit

class ClockFaceView: UIView {
    enum ClockHand {
        case minute
        case hour
    }
    
    var shapeLayer: CAShapeLayer!
    var circleLayer: CALayer!
    var hourHandLayer: CALayer!
    var minuteHandLayer: CALayer!
    var circlePath: UIBezierPath!
        
    var hourAngle: CGFloat {
        CGFloat(hours) / 12.0 * 2.0 * CGFloat.pi
    }
    
    private var hours: CGFloat = 0
    
    func set(hours: CGFloat,
             delay: Double = 0.0,
             duration: Double = 1) {
        let oldValue = self.hours
        self.hours = hours
        
        animate(clockHand: .hour,
                fromValue: CGFloat(oldValue) / 12.0 * 2.0 * CGFloat.pi,
                toValue: hourAngle,
                delay: delay,
                duration: duration)
    }
    
    var minuteAngle: CGFloat {
        CGFloat(minutes) / 60 * 2.0 * CGFloat.pi
    }

    private var minutes: CGFloat = 0
    
    func set(minutes: CGFloat,
             delay: Double = 0.0,
             duration: Double = 1) {
        let oldValue = self.minutes
        self.minutes = minutes
        
        animate(clockHand: .minute,
                fromValue: CGFloat(oldValue) / 60 * 2.0 * CGFloat.pi,
                toValue: minuteAngle,
                delay: delay,
                duration: duration)
    }
    
    override public func draw(_ rect: CGRect) {
        
        circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 0.5
        layer.addSublayer(shapeLayer)
        
        circleLayer = CALayer()
        circleLayer.frame = rect
        layer.addSublayer(circleLayer)
        
        hourHandLayer = CALayer()
        hourHandLayer.backgroundColor = UIColor.black.cgColor
        
        minuteHandLayer = CALayer()
        minuteHandLayer.backgroundColor = UIColor.black.cgColor

        let hDelta = rect.size.height * 0.2
        hourHandLayer.bounds = CGRect(x: 0,
                                      y: 0,
                                      width: 2,
                                      height: (rect.size.height / 2) - hDelta)
        hourHandLayer.position = .init(x: rect.size.width / 2,
                                       y: rect.height / 2)
        hourHandLayer.anchorPoint = CGPoint(x: 0.5,
                                            y: 1)
        let mDelta = rect.size.height * 0.1
        minuteHandLayer.frame = CGRect(x: rect.size.width / 2,
                                        y: mDelta,
                                        width: 2,
                                        height: (rect.size.height / 2) - mDelta)
        minuteHandLayer.position = .init(x: rect.size.width / 2,
                                         y: rect.height / 2)
        minuteHandLayer.anchorPoint = CGPoint(x: 0.5,
                                              y: 1)

        circleLayer.addSublayer(hourHandLayer)
        circleLayer.addSublayer(minuteHandLayer)
    }
    
    private func layer(by hand: ClockHand) -> CALayer {
        switch hand {
        case .hour:
            return hourHandLayer
        case .minute:
            return minuteHandLayer
        }
    }
    
    private func animate(clockHand: ClockHand,
                 fromValue: CGFloat,
                 toValue: CGFloat,
                 delay: Double,
                 duration: Double) {
        let handLayer = layer(by: clockHand)
        handLayer.transform = CATransform3DMakeRotation(toValue, 0, 0, 1)
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        if delay > 0 {
            animation.beginTime = CACurrentMediaTime() + delay
            animation.fillMode = .backwards
        }
        animation.autoreverses = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = fromValue
        animation.toValue = toValue
        handLayer.add(animation, forKey: "hoursHandAnimation")
    }
}

extension CAMediaTimingFunction {
    //https://www.objc.io/issues/12-animations/animations-explained/#timing-functions
    //The x-axis represents the fraction of the duration, while the y-axis is the input value of the interpolation function.
    var points: [CGPoint] {
        var point1 = [Float](repeating: 0.0, count: 2)
        var point2 = [Float](repeating: 0.0, count: 2)
        var point3 = [Float](repeating: 0.0, count: 2)
        var point4 = [Float](repeating: 0.0, count: 2)
        getControlPoint(at: 0, values: &point1)
        getControlPoint(at: 1, values: &point2)
        getControlPoint(at: 2, values: &point3)
        getControlPoint(at: 3, values: &point4)
        return [point1, point2, point3, point4]
            .compactMap({ (points) -> CGPoint? in
                guard let first = points.first,
                    let last = points.last else {return nil}
                return .init(x:CGFloat(first), y: CGFloat(last))
            })
    }
}
