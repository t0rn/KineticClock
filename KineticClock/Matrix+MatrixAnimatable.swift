//
//  Matrix+MatrixAnimatable.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 20.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import Foundation

extension Matrix: MatrixAnimatable where Element: ClockFaceView {
    func apply(animation: MatrixAnimationProtocol) {
//        let delays = animation.timingFunction.points.map{$0.x}
        //TODO: interpolate by timing function
        let interpolated: [Double]
        switch animation.direction {
        case .left:
            interpolated = [0, 0.105, 0.21, 0.42, 0.46, 0.50, 0.58, 0.72, 0.92, 1].reversed()
        case .right:
            interpolated = [0, 0.105, 0.21, 0.42, 0.46, 0.50, 0.58, 0.72, 0.92, 1]
        }
        self
            .enumerated()
            .forEach { (rowIndex, rows) in
                rows
                    .enumerated()
                    .forEach { (columnIndex, element) in
                        let delay = interpolated[rowIndex] * animation.delay
                        element.set(hours: animation.hours, delay: delay, duration: animation.duration)
                        element.set(minutes: animation.minutes, delay: delay, duration: animation.duration)
                }
        }
    }
}
