//
//  Routineaddexercisebutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/23.
//

import SwiftUI

struct Routineaddexercisebutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Routineaddexercisebutton()
        }
    }
}

struct Routineaddexercisebutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Workoutandeachlogmodel

    @State var shownewbatchlibrary: Bool = false
    var addbutton: some View {
        Button {
            shownewbatchlibrary.toggle()
        } label: {
            LocaleText("addexercises")
                .foregroundColor(.white)
                .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())
                .frame(width: LIBRARY_DOWNBAR_WIDTH, height: LIBRARY_DOWNBAR_HEIGHT)
                .background(
                    RoundedRectangle(cornerRadius: LIBRARY_BUTTON_CORNER_RADIUS)
                        .foregroundColor(preference.theme)
                )
        }
    }

    var body: some View {
        VStack {
            addbutton
        }
    }
}
