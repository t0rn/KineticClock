//
//  ViewController.swift
//  KineticClock
//
//  Created by Alexey Ivanov on 03.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var clocks: [[ClockFaceView]] = {
            let rows = 10
            let columns = 10
            return (1...rows).map { r -> [ClockFaceView] in
                (1...columns).map{ _ -> ClockFaceView in
                    let clockView = ClockFaceView(frame: .zero)
                    clockView.translatesAutoresizingMaskIntoConstraints = false
                    clockView.addConstraints([
                        clockView.widthAnchor.constraint(equalToConstant: 30),
                        clockView.heightAnchor.constraint(equalToConstant: 30)
                    ])
                    return clockView
                }
            }
        }()
    
        let datePicker = UIDatePicker(frame: .init(x: 40, y: 350, width: 250, height: 200))
        
        override func loadView() {
            let view = UIView()
            view.backgroundColor = .white
            view.addSubview(datePicker)
            let stackView = UIStackView(arrangedSubviews:
                clocks.map {
                    let stackView = UIStackView(arrangedSubviews: $0)
                    stackView.axis = .vertical
                    stackView.distribution = .fill
                    stackView.alignment = .fill
                    return stackView
                }
            )
            
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
        // Do any additional setup after loading the view.
    }

}

