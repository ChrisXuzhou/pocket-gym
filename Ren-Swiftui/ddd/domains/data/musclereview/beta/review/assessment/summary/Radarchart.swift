//
//  Radarchart.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/24.
//

import SwiftUI

struct RadarChart_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Musclefrequencyview()
        }

        DisplayedView {
            VStack {
                RadarChart(
                    data: [1, 2, 3, 4, 5, 6, 7],
                    gridColor: NORMAL_GRAY_COLOR,
                    dataColor: NORMAL_THEME_COLOR
                )
                .frame(width: UIScreen.width / 2, height: UIScreen.height / 2)
            }
        }
    }
}

struct MusclescoreradarView: View {
    @EnvironmentObject var assessmodel: Musclefrequencymodel

    /*
     * muscle displayed
     */
    @StateObject var librarymuscle = Librarynewdisplayedmuscle.shared

    var body: some View {
        ZStack {
            GeometryReader {
                reader in

                let w = reader.size.width
                let h = reader.size.height

                let positions: [(CGFloat, CGFloat)] = [(w / 2, 0), (w, h / 4), (w, 2 / 3 * h), (4 / 5 * w, h), (1 / 5 * w, h), (0, 2 / 3 * h), (0, h / 4)]
                
                let groups = librarymuscle.musclegroupids

                ForEach(0 ..< groups.count, id: \.self) {
                    idx in

                    LocaleText(groups[idx])
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
                        .position(x: positions[idx].0, y: positions[idx].1)
                        .shadow(color: NORMAL_BG_GRAY_COLOR, radius: 10)
                }

                let datas: [Double] = groups.map({ assessmodel.dictionary[$0]?.score ?? 0.0 })

                RadarChart(
                    data: datas,
                    gridColor: NORMAL_GRAY_COLOR,
                    dataColor: NORMAL_THEME_COLOR
                )
                .frame(width: w - 50, height: w - 50)
                .offset(x: 25, y: 25)
            }
        }
    }
}

struct RadarChartGrid: Shape {
    let categories: Int
    let divisions: Int

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
        let stride = radius / CGFloat(divisions)
        var path = Path()

        for category in 1 ... categories {
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
                                     y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius))
        }

        for step in 1 ... divisions {
            let rad = CGFloat(step) * stride
            path.move(to: CGPoint(x: rect.midX + cos(-.pi / 2) * rad,
                                  y: rect.midY + sin(-.pi / 2) * rad))

            for category in 1 ... categories {
                path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad,
                                         y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad))
            }
        }

        return path
    }
}

struct RadarChartPath: Shape {
    let data: [Double]

    func path(in rect: CGRect) -> Path {
        guard
            3 <= data.count,
            let minimum = data.min(),
            0 <= minimum,
            let maximum = data.max()
        else { return Path() }

        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
        var path = Path()

        for (index, entry) in data.enumerated() {
            switch index {
            case 0:
                path.move(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                      y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))

            default:
                path.addLine(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                         y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct RadarChart: View {
    var data: [Double]
    let gridColor: Color
    let dataColor: Color

    init(data: [Double], gridColor: Color = .gray, dataColor: Color = .blue) {
        self.data = data
        self.gridColor = gridColor
        self.dataColor = dataColor
    }

    var body: some View {
        ZStack {
            RadarChartGrid(categories: data.count, divisions: 3)
                .stroke(gridColor, lineWidth: 0.5)

            RadarChartPath(data: data)
                .fill(dataColor.opacity(0.3))

            RadarChartPath(data: data)
                .stroke(dataColor, lineWidth: 2.0)
        }
    }
}
