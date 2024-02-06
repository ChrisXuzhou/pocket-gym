//
//  Muscleradarcard.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/26.
//

import SwiftUI

func mockmusclevalue() -> Musclevalue {
    Musclevalue(muscleid: "chest", days: 3, rangedays: 10)
}

struct Muscleradarcard: View {
    @ObservedObject var valuesmodel: Muscleradarmodel

    /*
     * variables
     */
    var days: Int

    init(_ groupid: String, days: Int = 14) {
        self.days = days
        valuesmodel = Muscleradarmodel(groupid: groupid, days: days)
    }

    var body: some View {
        VStack(spacing: 0) {
            content
                .frame(height: CGFloat(valuesmodel.values.count) * 40)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(8)
        }
        .environmentObject(valuesmodel)
        .background(
            NORMAL_BG_CARD_COLOR
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 15)
    }

    var content: some View {
        ZStack {
            GeometryReader {
                r in

                let width = r.size.width
                let height = r.size.height

                if let patterns = MuscleEvaluation.shared.dictionary[valuesmodel.values.count] {
                    ForEach(0 ..< valuesmodel.values.count, id: \.self) {
                        idx in

                        let pattern: (CGFloat, CGFloat, CGFloat, CGFloat) = patterns.patterns[idx]
                        let value = valuesmodel.values[idx]

                        let _offsetx = pattern.0 * width
                        let _offsety = pattern.1 * height
                        let _w = pattern.2 * width
                        let _h = pattern.3 * height

                        Muscleradarcardpanel(days: days, value: value, width: _w, height: _h)
                            .offset(x: _offsetx, y: _offsety)
                    }
                }
            }
        }
    }
}

struct Muscleradarcardpanel: View {
    @EnvironmentObject var model: Muscleradarmodel

    var days: Int
    var value: Musclevalue
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        NavigationLink {
            NavigationLazyView(
                Muscleradardetailview(value.muscleid, days: days, workouttimes: value.days)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            )
        } label: {
            content
        }
        .isDetailLink(false)
    }

    var content: some View {
        VStack(spacing: 1) {
            Text("\(value.days)")
                .font(.system(size: DEFINE_FONT_SIZE).bold())

            LocaleText(value.muscleid, linelimit: 3, alignment: .center, linespacing: 1)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2))
                .padding(.horizontal)
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(width: width - 2, height: height - 2)
        .background(
            value.color // .opacity(0.6)
        )
        .frame(width: width, height: height)
    }
}
