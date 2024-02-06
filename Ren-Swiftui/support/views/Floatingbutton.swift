//
//  Floatingbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Floatingbutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Floatingbutton(label: "next",
                               disabled: true,
                               color: NORMAL_BLUE_COLOR)

                Floatingbutton(label: "next",
                               disabled: false,
                               color: NORMAL_BLUE_COLOR)
            }
        }
    }
}

let FLOATING_BUTTON_PADDING: CGFloat = 10

struct Floatingbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    
    var label: String
    var disabled = false
    var fontcolor: Color = .white
    var color: Color?
    
    var displayedcolor: Color {
        color ?? preference.theme
    }

    var body: some View {
        HStack {
            SPACE
            LocaleText(label, usefirstuppercase: false)
                .foregroundColor(fontcolor)
            SPACE
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        .frame(height: 46)
        .background(
            RoundedRectangle(
                cornerRadius: LIBRARY_BUTTON_CORNER_RADIUS
            )
            .foregroundColor(
                disabled ? displayedcolor.opacity(0.3) : displayedcolor
            )
            .shadow(color: displayedcolor.opacity(0.5),
                    radius: 8, x: 0, y: 5)
        )
        .ignoresSafeArea(.keyboard)
        //.padding(.bottom)
        //.padding(.horizontal, 5)
    }
}

struct LocalbuttonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
