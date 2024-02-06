//
//  Foldernameeditor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/4.
//

import Foundation

class Foldernameeditor: Texteditor {
    var folderwrapper: Folderwrapper

    init(_ folder: Folderwrapper) {
        folderwrapper = folder
    }

    func save(_ newvalue: String?) {
        folderwrapper.folder.name = newvalue ?? ""
        try! AppDatabase.shared.savefolder(&folderwrapper.folder)
        
        folderwrapper.objectWillChange.send()
    }
}
