//
//  Foldersmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/3.
//

import Foundation
import SwiftUI

func initsystemfolders() {
    let allfolders = AppDatabase.shared.queryallfolders()
    if allfolders.isEmpty {
        let systemfolders: [Folder] = [
            Folder(id: -1, name: "myroutines"),
            Folder(id: -11, parentid: -1, name: "beginner"),
            Folder(id: -12, parentid: -1, name: "intermediate"),
            Folder(id: -13, parentid: -1, name: "advanced"),
        ]

        for var folder in systemfolders {
            try! AppDatabase.shared.savefolder(&folder)
        }
    }

    let systemtemplates = AppDatabase.shared.queryworkouts(stats: .template, source: .system)
    var tosavetemplates: [Workout] = []
    for var template in systemtemplates {
        let level = template.oflevel

        if level == .beginner {
            template.folderid = -11
        }

        if level == .intermediate {
            template.folderid = -12
        }

        if level == .advanced {
            template.folderid = -13
        }

        tosavetemplates.append(template)
    }

    try! AppDatabase.shared.saveworkouts(&tosavetemplates)

    /*

     */
}

class Foldersmodel: ObservableObject {
    /*
     * set user opened folders
     */
    var openedfolderids = Set<Int64>()

    var rootfolders: [Folderwrapper] = []
    
    var allfolders: [Folderwrapper] {
        [Folderwrapper(EMPTY_FOLDER)] + rootfolders
    }
    
    func offocusedfolder(_ folderid: Int64) -> Folderwrapper {
        if folderid == EMPTY_FOLDER_ID {
            return EMPTY_FOLDER_WRAPPER
        }
        
        for each in rootfolders {
            if each.folderid == folderid {
                return each
            }
        }
        
        return EMPTY_FOLDER_WRAPPER
    }

    init() {
        openedfolderids.insert(EMPTY_FOLDER_ID)

        initfolders()
    }

    /*
     * temp value use
     */
    var parentfolderid2folderwrappers: [Int64: [Folderwrapper]] = [:]

    func initfolders() {
        Task.init {
            let allfolders = AppDatabase.shared.queryallfolders()
            if allfolders.isEmpty {
                return
            }

            let allfolderwrappers: [Folderwrapper] = allfolders.map({ Folderwrapper($0) })
            let parentfolderid2folderwrappers = Dictionary(grouping: allfolderwrappers, by: { $0.folder.parentid ?? -999 })

            for folderwrapper in allfolderwrappers {
                // find folder wrapper

                let folderid = folderwrapper.folder.id!
                if let children: [Folderwrapper] = parentfolderid2folderwrappers[folderid] {
                    folderwrapper.children = children
                    for eachchild in children {
                        eachchild.parent = folderwrapper
                    }
                }
            }

            let rootfolders =
                allfolderwrappers
                    .filter { $0.parent == nil }
                    .sorted { l, r in
                        if l.folder.order ?? -1 != r.folder.order ?? -1 {
                            return l.folder.order ?? -1 < r.folder.order ?? -1
                        }

                        return (l.folderid < r.folderid)
                    }

            /*
             
             let _allfolders = [Folderwrapper(EMPTY_FOLDER)] + rootfolders
             let dictionary = Dictionary(uniqueKeysWithValues: _allfolders.map({ ($0.folderid, $0) }))
             */

            DispatchQueue.main.async {
                self.parentfolderid2folderwrappers = parentfolderid2folderwrappers
                self.rootfolders = rootfolders
                /*
                 
                 self.allfolders = _allfolders
                 self.dictionary = dictionary
                 */

                self.objectWillChange.send()
            }
        }
    }
}

extension Foldersmodel {
    func isopened(_ folderid: Int64) -> Bool {
        openedfolderids.contains(folderid)
    }

    func open(_ folderwrapper: Folderwrapper) {
        if openedfolderids.contains(folderwrapper.folderid) {
            openedfolderids.remove(folderwrapper.folderid)
        } else {
            var openedfolderids = Set<Int64>()

            openedfolderids.insert(folderwrapper.folderid)

            var _folder = folderwrapper
            while _folder.parent != nil {
                let _parent = _folder.parent!
                openedfolderids.insert(_parent.folderid)

                _folder = _parent
            }

            self.openedfolderids = openedfolderids
        }

        objectWillChange.send()
    }

    func delete(_ folder: Folderwrapper) {
        if let idx = rootfolders.firstIndex(of: folder) {
            rootfolders.remove(at: idx)
        }

        folder.delete()

        objectWillChange.send()
    }

    func move(_ folder: Folderwrapper, newparentfolder: Folderwrapper? = nil) {
        folder.moveto(newparentfolder)

        if let idx = rootfolders.firstIndex(of: folder) {
            rootfolders.remove(at: idx)
        }

        if newparentfolder == nil {
            rootfolders.append(folder)
        }

        objectWillChange.send()
    }
}

extension Foldersmodel {
    static var shared = Foldersmodel()
}

extension Folderwrapper {
    func delete() {
        var todeletefolderids: [Int64] = []

        _deletefolder(todeletefolderids: &todeletefolderids)

        if !todeletefolderids.isEmpty {
            try! AppDatabase.shared.deletefolders(todeletefolderids)
            try! AppDatabase.shared.deleteroutines(todeletefolderids)
        }
    }

    func _deletefolder(todeletefolderids: inout [Int64]) {
        todeletefolderids.append(folderid)

        // 1. delete self
        if let _parent = parent {
            if let idx = _parent.children.firstIndex(of: self) {
                _parent.children.remove(at: idx)
            }
        }

        // 2. delete children
        for child in children {
            child._deletefolder(todeletefolderids: &todeletefolderids)
        }
    }
}

extension Folderwrapper {
    func moveto(_ newparent: Folderwrapper? = nil) {
        if let _parent = parent {
            if let idx = _parent.children.firstIndex(of: self) {
                _parent.children.remove(at: idx)
            }
        }

        if let _newparent = newparent {
            _newparent.children.append(self)
        }

        let newparentid: Int64? = newparent?.folder.id ?? nil
        folder.parentid = newparentid
        try! AppDatabase.shared.savefolder(&folder)
    }
}

extension Foldersmodel {
    func newfolder(_ parent: Folderwrapper? = nil, foldername: String = "newfolder") -> Folderwrapper {
        let parentid = parent?.folder.id

        var newfolder = Folder(
            parentid: parentid,
            name: PreferenceDefinition.shared.language(foldername)
        )
        try! AppDatabase.shared.savefolder(&newfolder)

        var wrapper: Folderwrapper

        if let _parent = parent {
            wrapper = Folderwrapper(newfolder, parent: _parent)
            _parent.children.insert(wrapper, at: 0)

        } else {
            wrapper = Folderwrapper(newfolder)
            rootfolders.insert(wrapper, at: 0)
        }

        objectWillChange.send()

        return wrapper
    }
}
