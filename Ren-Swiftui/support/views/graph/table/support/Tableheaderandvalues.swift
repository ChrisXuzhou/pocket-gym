//
//  Tableheader.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/3.
//

import SwiftUI

struct Tableheaderandvalues_Previews: PreviewProvider {
    static var previews: some View {
        let tablevaluelist = [
            Tablevalue(first: "15", second: 25.0),
            Tablevalue(first: "12", second: 30.0),
            Tablevalue(first: "8", second: 35.0),
            Tablevalue(first: "8", second: 35.0),
        ]

        DisplayedView {
            Tableheaderandvalues(
                idx: 0,
                total: 2,
                header: "上斜阿诺德哑铃卧推",
                tablevaluelist: tablevaluelist
            )
        }
    }
}

let TABLE_TAIL_WIDTH: CGFloat = 60

let TABLE_HEADER_ITEM_HEIGHT: CGFloat = 25
let TABLE_HEADER_COLOR: Color = NORMAL_LIGHTER_COLOR
let TABLE_HEADER_FONT_SIZE: CGFloat = DEFINE_FONT_SIZE - 2
let TABLE_HEADEREMPTY_SPACING: CGFloat = 15

let TABLE_DIVIDER: some View =
    RoundedRectangle(cornerRadius: 15)
        .frame(width: 1.5)
        .padding(.vertical, 1)

struct Tableheaderandvalues: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var tablevaluetype: Tablevaluetype = .tablevalue
    var idx: Int = 0
    var total: Int = 1
    let header: String
    let tablevaluelist: [Tablevalue?]

    var tablevaluewidth: CGFloat {
        switch tablevaluetype {
        case .tablevalue:
            return (UIScreen.width - TABLE_NUMBER_WIDTH - TABLE_TAIL_WIDTH - 20) / CGFloat(total - 1)
        case .tabletail:
            return TABLE_TAIL_WIDTH
        }
    }

    var tablevaluecontentwidth: CGFloat {
        tablevaluewidth - 20
    }

    var tablevaluelistheight: CGFloat {
        TABLE_VALUE_ITEM_HEIGHT * CGFloat(tablevaluelist.count)
    }

    var headerview: some View {
        VStack {
            Spacer(minLength: 0)

            HStack {
                LocaleText(header)
                    .foregroundColor(TABLE_HEADER_COLOR)
                    .font(.system(size: TABLE_HEADER_FONT_SIZE).bold())
                    .lineLimit(4)
                    .minimumScaleFactor(0.01)
                    .padding(.vertical, 3)

                Spacer(minLength: 0)
            }
            .frame(width: tablevaluecontentwidth)
        }
    }

    var valuelistview: some View {
        HStack {
            VStack(spacing: 2) {
                ForEach(0 ..< tablevaluelist.count, id: \.self) {
                    idx in

                    HStack(spacing: 2) {
                        if let tablevalue = tablevaluelist[idx] {
                            TABLE_DIVIDER
                                .foregroundColor(preference.themeprimarycolor)
                                .frame(height: TABLE_VALUE_ITEM_HEIGHT)

                            TablevalueView(tablevalue: tablevalue)
                        } else {
                            EmptyView()
                        }
                    }
                    .frame(height: TABLE_VALUE_ITEM_HEIGHT)
                }
            }

            Spacer(minLength: 0)
        }
    }

    var tableheaderviewheight: CGFloat {
        TABLE_HEADER_ITEM_HEIGHT * CGFloat(total - 1)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                /*
                 TABLE_DIVIDER
                     .foregroundColor(preference.themeprimarycolor)
                     .hidden()
                  */

                headerview

                Spacer(minLength: 0)
            }
            .frame(height: tableheaderviewheight)

            valuelistview
        }
        .frame(width: tablevaluewidth)
        // .background(Color(.systemGray4))
    }
}
