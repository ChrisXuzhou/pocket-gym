//
//  Libraryreplacedownbar.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/11.
//
import SwiftUI

struct Libraryreplacedownbar: View {
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var libraryusage: Libraryusage

    @Binding var present: Bool
    
    var callback: (_ libraryusage: Libraryusage) -> Void = {_ in }

    var body: some View {
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

extension Libraryreplacedownbar {
    /*
     * add button
     */
    var replacebutton: some View {
        Button {
            replace()
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

    func close() {
        present = false
    }

    func replace() {
        
        callback(libraryusage)

        close()
    }
}
