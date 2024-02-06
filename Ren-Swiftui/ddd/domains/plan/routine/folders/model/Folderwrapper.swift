//
//  Folderwrapper.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/3.
//

import Foundation

class Folderwrapper: ObservableObject, Hashable {
    var folder: Folder

    var parent: Folderwrapper?
    var children: [Folderwrapper] = []

    init(_ folder: Folder,
         parent: Folderwrapper? = nil, children: [Folderwrapper] = []) {
        self.folder = folder
        self.parent = parent
        self.children = children
    }
}

extension Folderwrapper {
    var folderid: Int64 {
        folder.id!
    }
}

extension Folderwrapper {
    static func == (lhs: Folderwrapper, rhs: Folderwrapper) -> Bool {
        lhs.folder.id == rhs.folder.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(folder.id)
    }
}
