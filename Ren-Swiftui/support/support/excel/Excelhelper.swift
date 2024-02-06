//
//  Excelhelper.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/3.
//

import Foundation
import CSV

func loadcsv(_ file: String) -> [[String]] {
    guard let filepath = Bundle.main.url(forResource: file, withExtension: nil) else {
        fatalError("error load excel: \(file)")
    }

    let stream = InputStream(url: filepath)!
    let csv = try! CSVReader(stream: stream, codecType: UTF8.self)

    var rows: [[String]] = []

    var idx = 0
    while let row: [String] = csv.next() {
        if idx != 0 {
            rows.append(row)
        }
        idx += 1
    }

    return rows
}

func writecsv(file: String, contents: [[String]]) {
    guard let filepath = Bundle.main.url(forResource: file, withExtension: nil) else {
        fatalError("error load excel: \(file)")
    }
    
    let stream = OutputStream(url: filepath, append: false)! //OutputStream(toFileAtPath: "/path/to/file.csv", append: false)!
    let csv = try! CSVWriter(stream: stream)

    for content: [String] in contents {
        try! csv.write(row: content)
    }

    csv.stream.close()
}
