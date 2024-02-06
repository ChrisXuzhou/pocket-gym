//
//  TablevalueView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/3.
//

import SwiftUI

struct TablevalueView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack(spacing: 0) {
                TablevalueView(tablevalue: Tablevalue(first: "15", second: 25.0))
                TablevalueView(tablevalue: Tablevalue(first: "150", second: 25.0))
                TablevalueView(tablevalue: Tablevalue(first: "150", second: 250.0))
            }
        }
    }
}

let TABLE_VALUE_ITEM_HEIGHT: CGFloat = 35
let TABLE_VALUE_FONT_SIZE: CGFloat = DEFINE_FONT_BIG_SIZE - 3

struct TablevalueView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    let tablevalue: Tablevalue

    func displaypairview(_ value: String?, _ footer: String?) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            if let _v = value {
                Text(_v)
            }

            if let _f = footer {
                Text(_f)
                    .font(.system(size: TABLE_VALUE_FONT_SIZE - 5).bold())
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.01)
        .font(.system(size: TABLE_VALUE_FONT_SIZE).bold())
        .foregroundColor(NORMAL_LIGHTER_COLOR)
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            displaypairview(tablevalue.first, tablevalue.firstfooter)

            if let _s = tablevalue.second {
                Image(systemName: "multiply")
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .foregroundColor(NORMAL_GRAY_COLOR)

                displaypairview(preference.displayweight(_s),
                                preference.ofweightunit.name)
            }

            Spacer(minLength: 0)
        }
        .padding(.trailing, 10)
    }
}
