//
//  ChartlineView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/8.
//

import LightChart
import SwiftUI

struct ChartlineView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                ChartlineView(
                    xlist: [
                        "2022.4.1",
                        "2022.4.2",
                        "2022.4.3",
                        "2022.4.5",
                    ],
                    ylist: [
                        2000.0,
                        1800.0,
                        2400.0,
                        2600.0,
                    ], displaylist: [
                        "2000.0",
                        "1800.0",
                        "2400.0",
                        "2600.0",
                    ]
                )

                ChartlineView(
                    xlist: [
                        "2022.4.1",
                        "2022.4.2",
                        "2022.4.3",
                        "2022.4.5",
                    ],
                    ylist: [
                        0,
                        0,
                        0,
                        0,
                    ], displaylist: [
                        "0.0",
                        "0.0",
                        "0.0",
                        "0.0",
                    ]
                )
            }
        }
        // .padding(.horizontal)
    }
}

let CHART_LINE_HEIGHT: CGFloat = UIScreen.height / 5
let CHART_LINE_X_WIDTH: CGFloat = (UIScreen.width - 50) / 5

struct ChartlineView: View {
    @EnvironmentObject var personal: PersonalDefinition

    var xlist: [String]
    var ylist: [Double]
    var displaylist: [String]

    var miny: Double
    var maxy: Double
    var offset: Double

    init(xlist: [String], ylist: [Double], displaylist: [String]) {
        self.xlist = xlist
        self.ylist = ylist
        self.displaylist = displaylist

        maxy = 0
        miny = 0
        offset = 0

        maxy = ylist.max() ?? 0
        if maxy == 0 {
            maxy = 1
        }
        miny = ylist.min() ?? 0
        offset = (miny / maxy) * 0.5
        
        if offset == 0 {
            offset = 0.1
        }
    }

    func yemptyspace(idx: Int) -> CGFloat {
        let y = ylist[idx]
        let height: Double =
            ((1.0 - offset) * ((y - miny) / (maxy - miny)) + offset) * abs(Double(CHART_LINE_HEIGHT) - 50.0)

        return CGFloat(abs(height))
    }

    var xlistview: some View {
        HStack(spacing: 0) {
            let _xlist = xlist

            ForEach(0 ..< _xlist.count, id: \.self) {
                idx in
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        SPACE

                        let displayed = displaylist[idx]
                        Text(displayed)
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 5))
                            .foregroundColor(NORMAL_GRAY_COLOR)
                            .frame(height: 20)

                        SPACE.frame(height: yemptyspace(idx: idx))

                        let x = _xlist[idx]
                        Text(x)
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 4).bold())
                            .foregroundColor(NORMAL_GRAY_COLOR)
                            .frame(height: 20)
                    }

                    SPACE
                }
                .frame(width: CHART_LINE_X_WIDTH)
            }
        }
    }

    var lineview: some View {
        VStack {
            SPACE.frame(height: 30)

            HStack {
                SPACE.frame(width: CHART_LINE_X_WIDTH / 8)

                LightChartView(
                    data: ylist,
                    visualType: .customFilled(
                        color: personal.themeprimarycolor,
                        lineWidth: 1.5,
                        fillGradient: LinearGradient(
                            gradient: .init(colors: [personal.themesecondarycolor, .clear]),
                            startPoint: .init(x: 0, y: 1),
                            endPoint: .init(x: 0, y: 0)
                        )
                    ),
                    offset: offset
                )
                .frame(width: CHART_LINE_X_WIDTH * Double(xlist.count - 1),
                       height: CHART_LINE_HEIGHT - 50)

                SPACE
            }

            SPACE
        }
    }

    var contentview: some View {
        ZStack {
            lineview

            xlistview
        }
        .frame(height: CHART_LINE_HEIGHT)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            contentview
                .offset(x: 0)
        }
    }
}
