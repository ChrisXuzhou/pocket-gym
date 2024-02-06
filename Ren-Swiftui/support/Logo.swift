//
//  Logo.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/6.
//

import Foundation
import SwiftUI

let LOGO: Image = Image("logo")

let MENU_LOWER_RECTANGLE: some View =
    RoundedRectangle(cornerRadius: 8)
        .frame(height: 2)
        .padding(0)

let SPACE: some View = Spacer(minLength: 0)

struct Logosmaller_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            SmallLogo(showimg: true)
        }
    }
}

struct Logosmaller: View {
    var body: some View {
        VStack(spacing: 8) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40, alignment: .center)
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
                .clipped()

            LocaleText(LANGUAGE_APPNAME)
                .foregroundColor(NORMAL_COLOR)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        }
    }
}

struct Logosmall: View {
    var showlogo: Bool = true
    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE

    var body: some View {
        VStack(spacing: 10) {
            if showlogo {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40, alignment: .center)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                    .clipped()
            }

            LocaleText(LANGUAGE_APPNAME)
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .font(.system(size: fontsize).bold())
                .padding(.top, 1)
        }
    }
}

struct SmallLogo: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var showimg: Bool = false
    var color: Color = NORMAL_LIGHTER_COLOR

    var body: some View {
        HStack(spacing: 12) {
            if showimg {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32, alignment: .center)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                    .clipped()
            }

            LocaleText(LANGUAGE_APPNAME)
                .foregroundColor(color)
                .font(.system(size: DEFINE_FONT_BIG_SIZE).weight(.heavy))
        }
    }
}

struct Logo: View {
    var showtitle = true

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 10) {
                SPACE

                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60, alignment: .center)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                    .clipped()

                if showtitle {
                    VStack(spacing: 6) {
                        LocaleText(LANGUAGE_APPNAME)
                            .foregroundColor(NORMAL_COLOR)
                            .font(.system(size: DEFINE_FONT_SIZE).bold())
                            .padding(.top, 8)

                        COPYRIGHT
                    }
                }

                SPACE.frame(height: UIScreen.height / 15)
            }
        }
    }
}
