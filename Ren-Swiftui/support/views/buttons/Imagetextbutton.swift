//
//  Imagetextbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/21.
//

import SwiftUI

struct Imagetextbutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            HStack {
                Imagetextbutton(
                    img: Image("calculator"),
                    imgsize: 25,
                    imgcolor: NORMAL_BLUE_COLOR,
                    text: "1rm",
                    textuppercase: true
                )

                Imagetextbutton(
                    img: Image("calculator"),
                    imgsize: 25,
                    imgcolor: NORMAL_BLUE_COLOR,
                    text: "1rmsss  sss",
                    textuppercase: true,
                    style: .horizontal
                )
            }
        }
    }
}

enum Imagetextbuttonstyle {
    case horizontal, vertical
}

struct Imagetextbutton: View {
    var img: Image
    var imgsize: CGFloat = 30
    var imgcolor: Color = NORMAL_BUTTON_COLOR
    var text: String
    var textuppercase: Bool = false
    var textfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 4
    var width: CGFloat = 60

    var style: Imagetextbuttonstyle = .vertical

    var verticalview: some View {
        VStack(spacing: 5) {
            HStack {
                SPACE
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imgsize, height: imgsize, alignment: .center)
                    .frame(width: 35, height: 35, alignment: .center)
                    .foregroundColor(imgcolor)

                SPACE
            }
            .frame(height: 35)

            LocaleText(text, uppercase: textuppercase, alignment: .center)
                .font(.system(size: textfontsize))
                .foregroundColor(imgcolor)

            SPACE
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(width: width, height: 80)
    }

    var horizontalview: some View {
        HStack(spacing: 5) {
            
            img
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imgsize, height: imgsize, alignment: .center)
                .frame(width: 35, height: 35, alignment: .center)
                .foregroundColor(imgcolor)

            LocaleText(text, uppercase: textuppercase, alignment: .leading)
                .font(.system(size: textfontsize))

            SPACE
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(width: width, height: 80)
    }

    var body: some View {
        VStack {
            switch style {
            case .horizontal:
                horizontalview
            case .vertical:
                verticalview
            }
        }
    }
}
