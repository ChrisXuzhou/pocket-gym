//
//  Usetemplatebuttom.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/31.
//


import SwiftUI

struct Routineusebutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                SPACE
                Routineusebutton()
            }
        }
    }
}

struct Routineusebutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var routine: Routine

    @StateObject var presetstartsheet = Viewopenswitch()

    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE
    var width: CGFloat = UIScreen.width
    var height: CGFloat = LIBRARY_DOWNBAR_HEIGHT
    var buttoncolor: Color? = nil
    var isrounded: Bool = false

    var _buttoncolor: Color {
        if let _buttoncolor: Color = buttoncolor {
            return _buttoncolor
        } else {
            return preference.theme
        }
    }

    var body: some View {
        Button {
            presetstartsheet.value = true
        } label: {
            HStack {
                SPACE

                LocaleText("usethistemplate")
                    .foregroundColor(.white)
                    .font(.system(size: fontsize).bold())

                SPACE
            }
            .frame(width: width, height: height)
            .background(
                VStack {
                    if isrounded {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(_buttoncolor)
                    } else {
                        _buttoncolor
                    }
                }.ignoresSafeArea()
            )
        }
        .sheetWithDetents(
            isPresented: $presetstartsheet.value,
            detents: [.medium()] // [.medium(),.large()]
        ) {
            Routineusesheet(present: $presetstartsheet.value, routine: routine)
                .environmentObject(trainingmodel)
                .environmentObject(preference)
        }
    }
}
