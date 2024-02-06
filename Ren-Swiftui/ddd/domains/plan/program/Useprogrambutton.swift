//
//  Useprogrambutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/1.
//

import SwiftUI


struct Useprogrambutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                SPACE
                Useprogrambutton()
            }
        }
    }
}

struct Useprogrambutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var programmodel: Programmodel

    @State var presetstartsheet = false

    var body: some View {
        Button {
            presetstartsheet = true
        } label: {
            HStack {
                SPACE
                LocaleText("usethisplan")
                    .foregroundColor(.white)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                SPACE
            }
            .frame(height: MIN_DOWN_BUTTON_HEIGHT)
            .background(
                preference.theme.ignoresSafeArea()
            )
        }
        .fullScreenCover(isPresented: $presetstartsheet) {
            Programstartdateview(present: $presetstartsheet)
                .environmentObject(preference)
                .environmentObject(programmodel)
        }
    }
}
