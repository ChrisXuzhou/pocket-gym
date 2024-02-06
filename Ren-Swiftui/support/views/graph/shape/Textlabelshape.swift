//
//  Textlabelshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/31.
//

import SwiftUI

struct Textlabelshape_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack(spacing: 30) {
                Textlabelshape(text: "D")

                Textlabelshape(text: "递")

                Textlabelshape(text: "F")

                Textlabelshape(text: "竭")
            }
        }
    }
}

struct Textlabelshape: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var text: String
    var color: Color = NORMAL_BLUE_COLOR

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(
                    color
                )

            LocaleText(text, alignment: .center)
                .font(
                    .system(size: DEFINE_FONT_SMALLEST_SIZE,
                            design: .rounded)
                    .weight(.heavy)
                )
                .foregroundColor(.white)
                
        }
        .frame(width: 20, height: 20)
    }
}
