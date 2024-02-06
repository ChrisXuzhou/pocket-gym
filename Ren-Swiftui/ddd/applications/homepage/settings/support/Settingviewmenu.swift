//
//  ConfigandselfieMenu.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/18.
//

import SwiftUI

struct Settingviewmenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Settingviewmenu(pagedto: .constant(.selfie))
        }
    }
}

let SETTING_MENU_WIDTH: CGFloat = (UIScreen.width - 10) / 3

struct Settingviewmenu: View {
    @Binding var pagedto: Settingtype

    var body: some View {
        HStack(spacing: 0) {
            SPACE
            SettingmenuIcon(pagedto: $pagedto, menu: .selfie)
            SettingmenuIcon(pagedto: $pagedto, menu: .config)
            SettingmenuIcon(pagedto: $pagedto, menu: .others)

            SPACE
        }
    }
}

let SETTING_MENU_HEIGHT: CGFloat = 25

struct SettingmenuIcon: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var pagedto: Settingtype
    var menu: Settingtype

    var isfocused: Bool {
        pagedto == menu
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            LocaleText(menu.label)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
            
            SPACE
            
            ZStack {
                
                MENU_LOWER_RECTANGLE
                    .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
                
                if isfocused {
                    MENU_LOWER_RECTANGLE
                        .foregroundColor(preference.theme)
                }
            }
        }
        .foregroundColor(
            isfocused ? NORMAL_LIGHTER_COLOR : NORMAL_GRAY_COLOR
        )
        .frame(width: SETTING_MENU_WIDTH, height: SETTING_MENU_HEIGHT)
        .onTapGesture {
            pagedto = menu
        }
    }
}
