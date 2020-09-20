//
//  MatrixAnimatable.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 20.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import Foundation

protocol MatrixAnimatable {
    func apply(animation: MatrixAnimationProtocol)
}
