//
//  Batchtitle.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import SwiftUI

let EXERCISE_NAME_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE

struct Batchtitle_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Batchtitle(
                    batchexercisedeflist: [mockbatchexercisedef(), mockbatchexercisedef()]
                )
            }
        }
    }
}

struct Batchtitle: View {
    var batchexercisedeflist: [Batchexercisedef]

    var firstexercisenameview: some View {
        HStack {
            let id: String = batchexercisedeflist.first?.ofexercisedef?.realname ?? ""

            LocaleText(id)
                .foregroundColor(NORMAL_COLOR)
                .font(.system(size: EXERCISE_NAME_FONT_SIZE).bold())
                .frame(alignment: .leading)
        }
    }

    var multiexercisenameview: some View {
        HStack(alignment: .lastTextBaseline) {
            let count: Int = batchexercisedeflist.count
            LocaleText(count < 3 ?
                LANGUAGE_SUPERGROUP :
                LANGUAGE_GIANTGROUP
            )

            Text("x \(count)")
                .foregroundColor(Color.orange)
        }
        .font(.system(size: EXERCISE_NAME_FONT_SIZE).bold())
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 3) {
            if batchexercisedeflist.count > 0 {
                if batchexercisedeflist.count == 1 {
                    firstexercisenameview
                } else {
                    multiexercisenameview
                }
            }
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
    }
}
