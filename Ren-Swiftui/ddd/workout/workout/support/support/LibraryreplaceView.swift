//
//  LibraryreplaceView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/11.
//

import SwiftUI

struct LibraryreplaceView: View {
    @EnvironmentObject var preference: PreferenceDefinition

    /*
     * variables
     */
    @StateObject var usage: Libraryusage = Libraryusage(usage: .forselect, libraryaction: Libraryaddexerciseaction())
    var callback: (_ libraryusage: Libraryusage) -> Void

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            Librarybetaview(showbackbutton: true, usage: usage) {
                callback(usage)
            }
            .edgesIgnoringSafeArea(.bottom)

            VStack {
                SPACE

                downbar
            }
        }
        .environmentObject(usage)
        .ignoresSafeArea(.keyboard)
    }
}


extension LibraryreplaceView {
    
    var downbar: some View {
        HStack(spacing: 0) {
            replacebutton
        }
        .clipShape(
            RoundedRectangle(cornerRadius: LIBRARY_BUTTON_CORNER_RADIUS)
        )
        .padding(.horizontal, 10)
        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 25)
    }
}

extension LibraryreplaceView {
    /*
     * add button
     */
    var replacebutton: some View {
        Button {
            callback(usage)
        } label: {
            HStack {
                SPACE

                LocaleText("replace")
                    .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())
                    .foregroundColor(.white)

                SPACE
            }
            .frame(height: MIN_DOWN_BUTTON_HEIGHT)
            .background(
                Rectangle().foregroundColor(preference.theme)
            )
        }
    }

}
