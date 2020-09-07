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
        //        CGFloat(hours * (360 / 12)) + CGFloat(minutes) * (1.0 / 60) * (360 / 12)
    }
    
    var hours: CGFloat = 0 {
        didSet {
            hourHandLayer.transform = CATransform3DMakeRotation(hourAngle, 0, 0, 1)
            // Create animation for hours hand
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
        //        CGFloat(minutes * (360 / 60))
    }
    
    var minutes: CGFloat = 0 {
        didSet {
            minuteHandLayer.transform = CATransform3DMakeRotation(minuteAngle, 0, 0, 1)
            // Create animation for minutes hand
            let minutesHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            minutesHandAnimation.duration = animationDuration
            minutesHandAnimation.isRemovedOnCompletion = false
            minutesHandAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            // From start angle (according to calculated angle from time) plus 360deg which equals 1 rotation
            minutesHandAnimation.fromValue = CGFloat(oldValue) / 60 * 2.0 * CGFloat.pi
            minutesHandAnimation.toValue = minuteAngle
            
            minuteHandLayer.add(minutesHandAnimation, forKey: "minutesHandAnimation")
        }
    }
    
    override public func draw(_ rect: CGRect) {
        // Take shorter of both sides
        if rect.size.width > rect.size.height {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        } else {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.width / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        }
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        layer.addSublayer(shapeLayer)
        
        circleLayer = CALayer()
        circleLayer.frame = rect
        layer.addSublayer(circleLayer)
        
        hourHandLayer = CALayer()
        hourHandLayer.backgroundColor = UIColor.black.cgColor
        hourHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        hourHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        
        minuteHandLayer = CALayer()
        minuteHandLayer.backgroundColor = UIColor.black.cgColor
        minuteHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        minuteHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        if rect.size.width > rect.size.height {
            hourHandLayer.bounds = CGRect(x: 0, y: 0, width: 2, height: (rect.size.height / 2) - (rect.size.height * 0.2))
            minuteHandLayer.bounds = CGRect(x: 0, y: 0, width: 2, height: (rect.size.height / 2) - (rect.size.height * 0.1))
            
        } else {
            hourHandLayer.bounds = CGRect(x: 0, y: 0, width: 2, height: (rect.size.width / 2) - (rect.size.width * 0.2))
            minuteHandLayer.bounds = CGRect(x: 0, y: 0, width: 2, height: (rect.size.width / 2) - (rect.size.width * 0.1))
        }
        
        circleLayer.addSublayer(hourHandLayer)
        circleLayer.addSublayer(minuteHandLayer)
    }
}
