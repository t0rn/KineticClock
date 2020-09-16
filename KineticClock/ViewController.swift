//
//  ViewController.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 03.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import UIKit

enum State {
    case clear //7:35
    case squares //6:45 + 12:45 + 12:15 + 6:15
}

class ViewController: UIViewController {
    var state: State = .clear
    
    lazy var clocks: Matrix<ClockFaceView> = {
        self.makeViews()
    }()
    
    let datePicker = UIDatePicker(frame: .init(x: 40, y: 350, width: 250, height: 200))
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(datePicker)
        let stackView = UIStackView(clocks)
        
        stackView.backgroundColor = .red
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.date = Date()
        datePicker.calendar = .init(identifier: .gregorian)
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        view.addConstraints([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8)
        ])
        
        self.view = view
    }
    
    @objc func dateChanged() {
        let time = datePicker.date
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour,.minute], from: time)
        if let hour = components.hour {
            clocks
                .flatMap{$0}
                .forEach{
                    $0.hours = CGFloat(hour)
            }
        }
        if let minute = components.minute {
            clocks
                .flatMap{$0}
                .forEach{
                    $0.minutes = CGFloat(minute)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.update(with: self.state)
        }
    }
    
    func update(with state: State) {
        switch state {
        case .clear:
            clocks
                .flatMap{$0}
                .forEach{
                    $0.hours = 7.0
                    $0.minutes = 35.0
            }
        case .squares:
           break
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

