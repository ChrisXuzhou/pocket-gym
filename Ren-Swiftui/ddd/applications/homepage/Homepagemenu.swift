//
//  Homepageicon.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/18.
//

import SwiftUI

struct Homepagemenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Homepageview()
        }
    }
}

let MIN_HOMEPAGE_MENU_HEIGHT: CGFloat = HOMEPAGE_ICON_SIZE
let MAX_HOMEPAGE_MENU_HEIGHT: CGFloat = UIScreen.height / 3

struct Homepagemenu: View {
    var body: some View {
        VStack {
            LIGHT_LOCAL_DIVIDER
            SPACE
            HStack(spacing: 0) {
                SPACE

                Homepageicon(
                    domain: .workouts,
                    img: "dumbbell",
                    displayname: true,
                    width: 28, height: 28
                )

                Calendarpageicon(
                    domain: .calendar,
                    displayname: true,
                    width: 24, height: 26
                )

                Homepageicon(
                    domain: .library,
                    img: "search",
                    displayname: true,
                    width: 20, height: 20
                )

                Homepageicon(
                    domain: .settings,
                    img: "gear",
                    displayname: true,
                    width: 24, height: 24
                )
                SPACE
            }
            SPACE
        }
        .frame(height: MIN_HOMEPAGE_MENU_HEIGHT)
        .background(NORMAL_BG_COLOR.ignoresSafeArea())
        .ignoresSafeArea(.keyboard)
    }
}

let HOMEPAGE_ICON_SIZE: CGFloat = MIN_DOWN_TAB_HEIGHT
let HOMEPAGE_ICON_IMAGE_SIZE: CGFloat = 26
let DOWNBAR_VERTICAL_SPACING: CGFloat = 10

struct Homepageicon: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var pageddomain: Pageddomain

    var domain: Homedomain
    var img: String
    var displayname: Bool = false

    var width: CGFloat = 35
    var height: CGFloat = 30

    var focused: Bool {
        pageddomain.pageddomain == domain
    }

    var unfocusedcolor: Color = NORMAL_BUTTON_COLOR

    var body: some View {
        HStack {
            SPACE

            ZStack {
                VStack(spacing: 0) {
                    Image(img)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: width, height: height)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 28)

                    SPACE

                    LocaleText(domain.rawValue)
                        .font(
                            .system(size: DEFINE_FONT_SMALLER_SIZE - 4)
                                .bold()
                        )
                }
                .frame(width: MENU_BUTTON_WIDTH, height: 40)
                .contentShape(Rectangle())
                .onTapGesture {
                    pageddomain.focus(domain)
                }
            }
            .foregroundColor(focused ? preference.theme : unfocusedcolor)

            SPACE
        }
        .frame(width: MENU_BUTTON_WIDTH, height: HOMEPAGE_ICON_SIZE, alignment: .center)
    }
}

let MENU_BUTTON_WIDTH: CGFloat = (UIScreen.width - 20) / 4

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        // .scaleEffect(configuration.isPressed ? 1.0 : 1.0)
    }
}
