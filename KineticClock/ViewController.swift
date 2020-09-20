//
//  ViewController.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 03.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import UIKit

enum AnimationDirection {
    case left
    case right
}

protocol MatrixAnimationProtocol {
    var duration: Double {get}
    var delay: Double {get}
    var hours: CGFloat {get}
    var minutes: CGFloat {get}
    var timingFunction: CAMediaTimingFunction {get}
    var direction: AnimationDirection {get}
}

struct WaveAnimation: MatrixAnimationProtocol {
    let duration: Double = 1.5
    let delay: Double = 1
    let hours: CGFloat
    let minutes: CGFloat
    let timingFunction: CAMediaTimingFunction
    let direction: AnimationDirection
}

struct ClearAnimation: MatrixAnimationProtocol {
    let duration: Double = 1.5
    let delay: Double = 1
    let hours: CGFloat = 7
    let minutes: CGFloat = 35
    let timingFunction: CAMediaTimingFunction = .init(name: .easeInEaseOut)
    let direction: AnimationDirection
}

//7:35
//6:45 + 12:45 + 12:15 + 6:15
//1:35


class ViewController: UIViewController {
    
    let animations: [MatrixAnimationProtocol] = [
        WaveAnimation(hours:1, minutes: 35, timingFunction: .init(name: .easeIn),direction: .left),
        WaveAnimation(hours:11, minutes: 15, timingFunction: .init(name: .easeInEaseOut), direction: .left),
        WaveAnimation(hours: 6, minutes: 0, timingFunction: .init(name: .linear), direction: .right),
        WaveAnimation(hours: 9, minutes: 15, timingFunction: .init(name: .easeOut), direction: .right),
        ClearAnimation(direction: .left)
    ]
    
    
    lazy var clocks: Matrix<ClockFaceView> = {
        self.makeViews()
    }()
    
    let datePicker = UIDatePicker(frame: .zero)
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(datePicker)
        let stackView = UIStackView(clocks)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.setTitle("Wave", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(button)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = Date()
        datePicker.calendar = .init(identifier: .gregorian)
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        view.addConstraints([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
        self.view = view
    }
    
    @objc func buttonPressed() {
        clocks.apply(animation: animations.randomElement()!)
    }
    
    @objc func dateChanged() {
        let time = datePicker.date
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour,.minute], from: time)
        if let hour = components.hour {
            clocks
                .flatMap{$0}
                .forEach{
                    $0.set(hours: CGFloat(hour))
            }
        }
        if let minute = components.minute {
            clocks
                .flatMap{$0}
                .forEach{
                    $0.set(minutes: CGFloat(minute))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.clocks.apply(animation: ClearAnimation(direction: .left))
        }
    }
    
    func makeViews() -> Matrix<ClockFaceView> {
        let rows = 10
        let columns = 10
        let elements = (1...rows)
            .map { _ -> [ClockFaceView] in
                (1...columns)
                    .map{ _ -> ClockFaceView in
                        let clockView = ClockFaceView(frame: .zero)
                        clockView.translatesAutoresizingMaskIntoConstraints = false
                        clockView.addConstraints([
                            clockView.widthAnchor.constraint(equalToConstant: 40),
                            clockView.heightAnchor.constraint(equalToConstant: 40)
                        ])
                        return clockView
                }
        }
        guard let matrix = Matrix<ClockFaceView>(elements) else { fatalError() }
        return matrix
    }
}
