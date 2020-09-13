//
//  ClockFaceView.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 07.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import UIKit

class ClockFaceView: UIView {
    let animationDuration = 1.0
    var shapeLayer: CAShapeLayer!
    var circleLayer: CALayer!
    var hourHandLayer: CALayer!
    var minuteHandLayer: CALayer!
    var circlePath: UIBezierPath!
    
    var hourAngle: CGFloat {
        CGFloat(hours) / 12.0 * 2.0 * CGFloat.pi
    }
    
    var hours: CGFloat = 0 {
        didSet {
            hourHandLayer.transform = CATransform3DMakeRotation(hourAngle, 0, 0, 1)
            let hoursHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            hoursHandAnimation.duration = animationDuration
            hoursHandAnimation.isRemovedOnCompletion = false
            hoursHandAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            hoursHandAnimation.fromValue = CGFloat(oldValue) / 12.0 * 2.0 * CGFloat.pi
            hoursHandAnimation.toValue = hourAngle
            hourHandLayer.add(hoursHandAnimation, forKey: "hoursHandAnimation")
        }
    }
    var minuteAngle: CGFloat {
        CGFloat(minutes) / 60 * 2.0 * CGFloat.pi
    }
    
    var minutes: CGFloat = 0 {
        didSet {
            minuteHandLayer.transform = CATransform3DMakeRotation(minuteAngle, 0, 0, 1)
            // Create animation for minutes hand
            let minutesHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            minutesHandAnimation.duration = animationDuration
            minutesHandAnimation.isRemovedOnCompletion = false
            minutesHandAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            minutesHandAnimation.fromValue = CGFloat(oldValue) / 60 * 2.0 * CGFloat.pi
            minutesHandAnimation.toValue = minuteAngle
            
            minuteHandLayer.add(minutesHandAnimation, forKey: "minutesHandAnimation")
        }
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
                                      width: 1,
                                      height: (rect.size.height / 2) - hDelta)
        hourHandLayer.position = .init(x: rect.size.width / 2,
                                       y: rect.height / 2)
        hourHandLayer.anchorPoint = CGPoint(x: 0.5,
                                            y: 1)
        let mDelta = rect.size.height * 0.1
        minuteHandLayer.frame = CGRect(x: rect.size.width / 2,
                                        y: mDelta,
                                        width: 1,
                                        height: (rect.size.height / 2) - mDelta)
        minuteHandLayer.position = .init(x: rect.size.width / 2,
                                         y: rect.height / 2)
        minuteHandLayer.anchorPoint = CGPoint(x: 0.5,
                                              y: 1)

        circleLayer.addSublayer(hourHandLayer)
        circleLayer.addSublayer(minuteHandLayer)
    }
}
