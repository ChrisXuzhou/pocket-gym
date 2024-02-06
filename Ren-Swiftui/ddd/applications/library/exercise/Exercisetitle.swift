//
//  Exercisetitle.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/17.
//

import SwiftUI

struct Exercisetitle: View {
    var exerciselist: [Newdisplayedexercise]
    var fontsize: CGFloat = DEFINE_FONT_SIZE

    var firstexercisenameview: some View {
        HStack {
            let id: String = exerciselist.first?.realname ?? ""

            LocaleText(id)
                .frame(alignment: .leading)
        }
    }

    var multiexercisenameview: some View {
        HStack(alignment: .lastTextBaseline) {
            let count: Int = exerciselist.count
            LocaleText(count < 3 ? LANGUAGE_SUPERGROUP : LANGUAGE_GIANTGROUP,
                       uppercase: true)

            Text("x \(count)")
                .foregroundColor(Color.orange)
                .bold()
        }
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 3) {
            if exerciselist.count > 0 {
                if exerciselist.count == 1 {
                    firstexercisenameview
                } else {
                    multiexercisenameview
                }
            }
        }
        .font(
            .system(size: fontsize, design: .rounded)
            // .bold()
        )
        .foregroundColor(NORMAL_LIGHTER_COLOR)
    }
}
