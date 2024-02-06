//
//  CalendarIcon.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/4.
//

import SwiftUI

struct Calendarpageicon_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Homepageview()
        }
        .environmentObject(Trainingmodel())
    }
}

struct Calendarpageicon: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var pageddomain: Pageddomain

    var day: Date = Date()
    var domain: Homedomain
    var img: String?
    var displayname: Bool = false

    var width: CGFloat = 23
    var height: CGFloat = 16

    var focused: Bool {
        pageddomain.pageddomain == domain
    }

    var unfocusedcolor: Color = NORMAL_BUTTON_COLOR

    var body: some View {
        HStack {
            SPACE

            /*
             ZStack {
                 Button {
                     pageddomain.focus(domain)
                 } label: {
                     VStack {
                         ZStack {
                             Image("calendar")
                                 .renderingMode(.template)
                                 .resizable()
                                 .frame(width: width, height: height)
                                 .aspectRatio(contentMode: .fill)

                             Text("\(day.day)")
                                 .font(.system(size: 9, design: .rounded).weight(.bold))
                                 .foregroundColor(NORMAL_BG_COLOR)
                                 .offset(y: 4)
                         }
                         .frame(height: 29)

                         SPACE
                     }
                     .frame(width: MENU_BUTTON_WIDTH, height: 40)
                 }
                 .buttonStyle(GradientButtonStyle())

                 if displayname {
                     VStack {
                         SPACE

                         LocaleText(domain.rawValue)
                             .font(
                                 .system(size: DEFINE_FONT_SMALLER_SIZE - 4)
                                     .bold()
                             )
                     }
                     .frame(height: 40)
                 }
             }
             */
            VStack {
                ZStack {
                    Image("calendar")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: width, height: height)
                        .aspectRatio(contentMode: .fill)

                    Text("\(day.day)")
                        .font(.system(size: 9, design: .rounded).weight(.bold))
                        .foregroundColor(NORMAL_BG_COLOR)
                        .offset(y: 4)
                }
                .frame(height: 29)

                SPACE
                
                LocaleText(domain.rawValue)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 4).bold())
            }
            .frame(width: MENU_BUTTON_WIDTH, height: 40)
            .contentShape(Rectangle())
            .onTapGesture {
                pageddomain.focus(domain)
            }
            .foregroundColor(focused ? preference.theme : unfocusedcolor)

            SPACE
        }
        .frame(width: MENU_BUTTON_WIDTH, height: HOMEPAGE_ICON_SIZE, alignment: .center)
    }
}
