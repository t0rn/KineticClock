//
//  Matrix.swift
//  FastICA_CLI
//
//  Created by Alexey Ivanov on 14.09.2020.
//  Copyright © 2020 Alexey Ivanov. All rights reserved.
//

import Foundation

struct Matrix<Element> {
    let rows: Int
    let columns: Int
    
    private(set) var elements: [Element]
    
    init(rows: Int, columns: Int, repeatedValue: Element) {
        self.rows = rows
        self.columns = columns
        self.elements = [Element](repeating: repeatedValue, count: rows * columns)
    }
    
    init?(_ elements: [[Element]]) {
        guard let first = elements.first,
            elements.count == first.count
            else {
                //"All rows should have the same number of columns"
                return nil
        }
        self.rows = elements.count
        self.columns = first.count
        self.elements = elements.flatMap{$0}
    }
    
}

extension Matrix: CustomStringConvertible {
    public var description: String {
        var description = ""

        for i in 0..<rows {
            let contents = (0..<columns).map { "\(self[i, $0])" }.joined(separator: "\t")

            switch (i, rows) {
            case (0, 1):
                description += "(\t\(contents)\t)"
            case (0, _):
                description += "⎛\t\(contents)\t⎞"
            case (rows - 1, _):
                description += "⎝\t\(contents)\t⎠"
            default:
                description += "⎜\t\(contents)\t⎥"
            }

            description += "\n"
        }

        return description
    }
}

extension Matrix: Collection {
    
    public subscript(_ row: Int) -> ArraySlice<Element> {
        let startIndex = row * columns
        let endIndex = startIndex + columns
        return elements[startIndex..<endIndex]
    }

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return self.rows
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }
}

extension Matrix {
    
    public subscript(row: Int, column: Int) -> Element {
        get {
            assert(indexIsValidForRow(row, column: column))
            return elements[(row * columns) + column]
        }

        set {
            assert(indexIsValidForRow(row, column: column))
            elements[(row * columns) + column] = newValue
        }
    }

    public subscript(row row: Int) -> [Element] {
        get {
            assert(row < rows)
            let startIndex = row * columns
            let endIndex = row * columns + columns
            return Array(elements[startIndex..<endIndex])
        }

        set {
            assert(row < rows)
            assert(newValue.count == columns)
            let startIndex = row * columns
            let endIndex = row * columns + columns
            elements.replaceSubrange(startIndex..<endIndex, with: newValue)
        }
    }

    public subscript(column column: Int, repeating: Element) -> [Element] {
        get {
            var result = [Element](repeating: repeating, count: rows)
            for i in 0..<rows {
                let index = i * columns + column
                result[i] = self.elements[index]
            }
            return result
        }

        set {
            assert(column < columns)
            assert(newValue.count == rows)
            for i in 0..<rows {
                let index = i * columns + column
                elements[index] = newValue[i]
            }
        }
    }

    private func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
}
