//
//  Tablenumbers.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/4.
//

import SwiftUI

let TABLE_NUMBER_WIDTH: CGFloat = 30

struct Tablenumbers: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var rowcount: Int = 1
    var columncount: Int = 1

    var tableheaderviewheight: CGFloat {
        TABLE_HEADER_ITEM_HEIGHT * CGFloat(columncount - 1)
    }

    var emptysapaceview: some View {
        VStack {
            Text("1").hidden()
            Spacer()
        }
        .frame(height: tableheaderviewheight)
    }

    func numberview(_ number: Int) -> some View {
        HStack {
            Spacer(minLength: 0)

            Text("\(number)")
                .lineLimit(1)
                .minimumScaleFactor(0.01)
                .font(.system(size: DEFINE_FONT_SIZE - 2).bold())
                .frame(width: 25)
        }
        .foregroundColor(preference.theme)
        .frame(width: TABLE_NUMBER_WIDTH,
               height: TABLE_VALUE_ITEM_HEIGHT)
    }

    var body: some View {
        VStack(spacing: 2) {
            emptysapaceview

            VStack(spacing: 2) {
                ForEach(0 ..< rowcount, id: \.self) {
                    number in
                    numberview(number + 1)
                }
            }
        }
    }
}

struct Tablenumbers_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Tablenumbers(rowcount: 2, columncount: 4)
            Tablenumbers(rowcount: 14, columncount: 3)
        }
    }
}
