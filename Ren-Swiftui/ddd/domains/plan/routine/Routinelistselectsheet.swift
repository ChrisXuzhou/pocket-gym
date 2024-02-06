//
//  Routinelistselectsheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/30.
//

import SwiftUI

struct Routinelistselectsheet: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var presentmode
    @Binding var present: Bool

    var routineselected: ((_ routineid: Int64) -> Void)?
    
    var upheader: some View {
        HStack {
            Button {
                presentmode.wrappedValue.dismiss()
                present = false
            } label: {
                CLOSE_IMG
            }

            SPACE

            LocaleText("selecttemplates")
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            SPACE.frame(width: 20)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(
            NORMAL_BG_COLOR.ignoresSafeArea()
        )
    }

    var contentview: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Routinetreeview(viewusage: .forselect) {
                selectedid in

                if let _routineselected = routineselected {
                    _routineselected(selectedid)
                }

                DispatchQueue.main.async {
                    present = false
                }
            }

            SPACE
        }
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR

            VStack(spacing: 0) {
                upheader
                
                contentview
            }
        }
    }
}
