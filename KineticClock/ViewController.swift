//
//  ViewController.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 03.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import UIKit

enum IterationStyle {
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
}

protocol ClockAnimatable {
    var duration: Double {get}
    var delay: Double {get}
    var hours: CGFloat {get}
    var minutes: CGFloat {get}
    var timingFunction: CAMediaTimingFunction {get}
    var iterationStyle: IterationStyle {get}
}

struct WaveAnimation: ClockAnimatable {
    let duration: Double = 1.5
    let delay: Double = 1
    let hours: CGFloat
    let minutes: CGFloat
    let timingFunction: CAMediaTimingFunction
    let iterationStyle: IterationStyle
}

struct ClearAnimation: ClockAnimatable {
    let duration: Double = 1.5
    let delay: Double = 1
    let hours: CGFloat = 7
    let minutes: CGFloat = 35
    let timingFunction: CAMediaTimingFunction = .init(name: .easeInEaseOut)
    let iterationStyle: IterationStyle
}

//7:35
//6:45 + 12:45 + 12:15 + 6:15
//1:35


class ViewController: UIViewController {
    
    let animations: [ClockAnimatable] = [
        WaveAnimation(hours:1, minutes: 35, timingFunction: .init(name: .easeIn),iterationStyle: .topLeft),
        WaveAnimation(hours:11, minutes: 15, timingFunction: .init(name: .easeInEaseOut), iterationStyle: .bottomLeft),
        WaveAnimation(hours: 6, minutes: 0, timingFunction: .init(name: .linear), iterationStyle: .topRight),
        WaveAnimation(hours: 9, minutes: 15, timingFunction: .init(name: .easeOut), iterationStyle: .bottomRight),
        ClearAnimation(iterationStyle: .topLeft)
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
        apply(animation: animations.randomElement()!)
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
            self.apply(animation: ClearAnimation(iterationStyle: .topLeft))
        }
    }
    
    //TODO: move it to ClockView
    func apply(animation: ClockAnimatable) {
        let delays = (0...3).map{animation.timingFunction.points[$0].x * CGFloat(animation.delay)}
        print(delays)
                
        let matrix: Matrix<ClockFaceView>
        switch animation.iterationStyle {
        case .topLeft:
            matrix = clocks
        case .bottomRight:
            let elements: [[ClockFaceView]] = clocks.reversed().map{$0.reversed()}
            matrix = Matrix<ClockFaceView>(elements)!
        case .topRight:
            let elements: [[ClockFaceView]] = clocks.reversed().map{$0.reversed().reversed()} //lol
            matrix = Matrix<ClockFaceView>(elements)!
        case .bottomLeft:
            let elements: [[ClockFaceView]] = clocks.map{$0.reversed()}
            matrix = Matrix<ClockFaceView>(elements)!
        }
        matrix
            .enumerated()
            .forEach { (rowIndex, row) in
                row
                    .enumerated()
                    .forEach { (offset, element) in
                        let delay = (animation.delay / Double((offset + 1) * (rowIndex + 1)))
                        element.set(hours: animation.hours, delay: delay, duration: animation.duration)
                        element.set(minutes: animation.minutes, delay: delay, duration: animation.duration)
                }
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

