//
//  Activityviewmenu.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/5.
//

import SwiftUI

struct Activityviewmenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Activityviewmenu(pagedto: .constant(.calendar))
        }
    }
}

enum Activitypagedto: String {
    case calendar, data
}

struct Activityviewmenuicon: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var pagedto: Activitypagedto

    let menu: Activitypagedto

    var focused: Bool {
        menu == pagedto
    }

    var body: some View {
        VStack(spacing: 5) {
            LocaleText(menu.rawValue)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(
                    focused ? NORMAL_LIGHTER_COLOR : NORMAL_GRAY_COLOR
                )

            if focused {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 30, height: 5)
                    .foregroundColor(preference.theme)
            }

            SPACE
        }
        .frame(width: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            pagedto = menu
        }
    }
}

struct Activityviewmenu: View {
    @Binding var pagedto: Activitypagedto

    var body: some View {
        HStack(spacing: 0) {
            SPACE

            Activityviewmenuicon(pagedto: $pagedto, menu: .calendar)

            Activityviewmenuicon(pagedto: $pagedto, menu: .data)

            SPACE
        }
        .frame(height: 40)
    }
}
