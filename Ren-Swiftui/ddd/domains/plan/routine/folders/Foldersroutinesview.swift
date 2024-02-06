//
//  Foldersroutinesviewview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/3.
//

import SwiftUI

let LINE_COLOR = NORMAL_LIGHT_GRAY_COLOR.opacity(0.3)

struct Foldersroutinesview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Workoutsview()
        }
    }
}

struct Foldersroutinesview: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var foldersmodel: Foldersmodel
    @EnvironmentObject var routinesmodel: Folderroutinesmodel
    @EnvironmentObject var isopened: Menuisopen

    var viewusage: Labelusage = .forview
    var onselected: (Int64) -> Void = { _ in }

    /*
     * function variables
     */
    let columns = [
        GridItem(.fixed((UIScreen.width - 30) / 2)),
        GridItem(.fixed((UIScreen.width - 30) / 2)),
    ]

    var body: some View {
        columnroutines
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .background(NORMAL_BG_COLOR)
    }
}

extension Foldersroutinesview {
    var columnroutines: some View {
        LazyVStack(spacing: 10) {
            if let _routines = routinesmodel.searchroutines(isopened.openedfolderid, focused: isopened.focused) {
                ForEach(0 ..< _routines.count, id: \.self) {
                    idx in
                    let routine = _routines[idx]

                    Folderroutine(
                        routine,
                        labelusage: viewusage,
                        onselected: onselected
                    )
                }
            }
        }
    }

    /*
     * show routines in vgrids
     */
    var gridroutines: some View {
        VStack {
            if let _routines = routinesmodel.folderid2routines[isopened.openedfolderid] {
                if _routines.isEmpty {
                    Emptycontentpanel()
                }

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0 ..< _routines.count, id: \.self) {
                        idx in
                        let routine = _routines[idx]

                        Folderroutine(
                            routine,
                            labelusage: viewusage, onselected: onselected)
                            .frame(height: FOLDER_ROUTINE_HEIGHT)
                    }
                }
            }
        }
    }
}
