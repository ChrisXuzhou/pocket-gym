//
//  Exerciseviewmenu.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/27.
//

import SwiftUI

struct Exerciseviewmenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Exerciseviewmenu(
                pagedto: .constant(.results)
            )
        }
    }
}

let EXERCISE_HISTORY_OR_EXPLAIN_FONT: CGFloat = DEFINE_FONT_SMALL_SIZE - 2
let EXERCISE_HISTORY_OR_EXPLAIN_WIDTH: CGFloat = 70
let EXERCISE_HISTORY_OR_EXPLAIN_HEIGHT: CGFloat = 30

struct Exerciseviewmenu: View {
    @Binding var pagedto: Exerciseviewtype

    var body: some View {
        HStack {
            SPACE
            Exerciseviewmenuicon(pagedto: $pagedto, menu: .exercise)
            Exerciseviewmenuicon(pagedto: $pagedto, menu: .results)

            SPACE
        }
    }
}

struct Exerciseviewmenuicon: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var pagedto: Exerciseviewtype
    var menu: Exerciseviewtype

    var isfocused: Bool {
        pagedto == menu
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            LocaleText(menu.name)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .lineLimit(1)
                .minimumScaleFactor(0.01)

            if isfocused {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 30, height: 5)
                    .foregroundColor(preference.theme)
                    .padding(.top, 5)
            }

            SPACE
            HStack { SPACE }
        }
        .foregroundColor(
            isfocused ? .primary.opacity(0.7) : Color(.systemGray)
        )
        .frame(width: EXERCISE_HISTORY_OR_EXPLAIN_WIDTH, height: EXERCISE_HISTORY_OR_EXPLAIN_HEIGHT)
        .onTapGesture {
            pagedto = menu
        }
    }
}
