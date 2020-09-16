//
//  UIStackView+Matrix.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 16/09/2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init<T:UIView>(_ matrix: Matrix<T>,
                               spacing: CGFloat = .zero) {
        self
            .init(arrangedSubviews:
                matrix
                    .map{
                        let stackView = UIStackView(arrangedSubviews: Array($0))
                        stackView.axis = .vertical
                        stackView.distribution = .fill
                        stackView.alignment = .fill
                        stackView.spacing = spacing
                        return stackView
                }
        )
    }
}
