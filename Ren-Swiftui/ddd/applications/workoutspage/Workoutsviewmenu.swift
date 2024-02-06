//
//  SwiftUIView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/28.
//

import SwiftUI

struct Workoutsviewmenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Workoutsviewmenu(pagedto: .constant(.reviews))
        }
    }
}

let MENUSUBLINE: AnyView = AnyView(
    RoundedRectangle(cornerRadius: 3)
        .frame(width: 20, height: 5)
)

public var PAGEDWORKOUTVIEW_KEY = "pagedworkoutview"

struct Workoutsviewmenuicon: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var pagedto: Workoutsviewmenupagedto

    let menu: Workoutsviewmenupagedto

    var focused: Bool {
        menu == pagedto
    }

    var body: some View {
        VStack(spacing: 0) {
            LocaleText(menu.rawValue)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(
                    focused ? NORMAL_LIGHTER_COLOR : NORMAL_GRAY_COLOR
                )

            SPACE

            if focused {
                MENUSUBLINE
                    .foregroundColor(preference.theme)
            }
        }
        .frame(width: 80)
        .contentShape(Rectangle())
        .onTapGesture {
            pagedto = menu

            DispatchQueue.global().async {
                var appcache = Appcache(cachekey: PAGEDWORKOUTVIEW_KEY, cachevalue: menu.rawValue)
                try! AppDatabase.shared.saveappcache(&appcache)
            }
        }
    }
}

enum Workoutsviewmenupagedto: String, CaseIterable {
    case workouts, reviews

    var index: Int {
        switch self {
        case .workouts:
            return 0
        case .reviews:
            return 1
        }
    }
    
    var offsetx: CGFloat {
        switch self {
        case .workouts:
            return 0
        case .reviews:
            return 115
        }
    }
}

struct Workoutsviewmenu: View {
    @Binding var pagedto: Workoutsviewmenupagedto

    var body: some View {
        HStack(spacing: 0) {
            SPACE

            ForEach(Workoutsviewmenupagedto.allCases, id: \.self) {
                pagedto in
                Workoutsviewmenuicon(pagedto: $pagedto, menu: pagedto)
            }

            SPACE
        }
        .font(.system(size: DEFINE_FONT_SIZE))
        .frame(height: 32)
    }
}
