//
//  Labelbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/21.
//

import SwiftUI

struct Labelbutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            HStack {
                Labelbutton(img: Image("makeaplan"),
                            bgcolor: NORMAL_GREEN_COLOR,
                            text: "makeaplan",
                            subtext: "usetemplatedesc"
                )

                Labelbutton(img: Image("exercise"),
                            bgcolor: NORMAL_BLUE_COLOR,
                            text: "startaexercise",
                            subtext: "startaexercisedesc"
                )
            }
        }
    }
}

let LABEL_BUTTON_WIDTH: CGFloat = (UIScreen.width - 30) / 2

struct Labelbutton: View {
    var img: Image
    var imgsize: CGFloat = 35
    var imgcolor: Color = .white

    var bgcolor: Color

    var text: String
    var textfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE

    var subtext: String?
    var subtextfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 4

    var contentview: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 0) {
                LocaleText(text)
                    .font(.system(size: textfontsize).bold())

                SPACE
            }
            if let _subtext = subtext {
                HStack(spacing: 0) {
                    LocaleText(_subtext, linelimit: 2)
                        .font(.system(size: subtextfontsize).bold())

                    SPACE.frame(maxWidth: 25)
                }
            }
            
            SPACE
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .foregroundColor(.white)
    }

    var imgview: some View {
        VStack {
            SPACE
            HStack {
                SPACE
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imgsize, height: imgsize, alignment: .center)
                    .padding(5)
            }
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(bgcolor)

            imgview

            contentview
        }
        .frame(width: LABEL_BUTTON_WIDTH, height: 80)
    }
}
