//
//  Workoutsfocusedview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/12/4.
//

import SwiftUI

struct Workoutsfocusedview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Workoutsfocusedview()
                .environmentObject(Folderroutinesmodel.shared)
        }
    }
}

struct Workoutsfocusedview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var present

    @EnvironmentObject var routinesmodel: Folderroutinesmodel

    var viewusage: Labelusage = .forview
    var onselected: (Int64) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            upheader

            ScrollView(.vertical, showsIndicators: false) {
                gridroutines.padding(.vertical)
                
                SPACE
                
                Copyright()
            }
        }
    }

    /*
     * function variables
     */
    let columns = [
        GridItem(.fixed((UIScreen.width - 30) / 2)),
        GridItem(.fixed((UIScreen.width - 30) / 2)),
    ]
}

extension Workoutsfocusedview {
    var upheader: some View {
        HStack(spacing: 10) {
            Button {
                present.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }

            SPACE

            LocaleText("mark")
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            SPACE.frame(width: 18)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(NORMAL_BG_COLOR)
    }

    var gridroutines: some View {
        VStack {
            if let _routines = routinesmodel.focusedtemplates {
                if _routines.isEmpty {
                    Emptycontentpanel().padding(.top, UIScreen.height / 4)
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
