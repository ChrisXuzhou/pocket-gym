//
//  Exerciseresultchart.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/11.
//

import Charts
import SwiftUI

struct Exercisechart_Previews: PreviewProvider {
    static var previews: some View {
        // let analysisedlist: [Analysisedexercise] = fetchanalysisedlist()

        let analysisedlist = [
            Analysisedexercise(exerciseid: 19009,
                               workoutid: -1,
                               batchid: -1,
                               workday: Date(),
                               volume: 2300, onerm: 102,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 95),
            Analysisedexercise(exerciseid: 19009,
                               workoutid: -2,
                               batchid: -1,
                               workday: Date(),
                               volume: 2800, onerm: 105,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
            Analysisedexercise(exerciseid: 19009,
                               workoutid: -3,
                               batchid: -1,
                               workday: Date(),
                               volume: 2900, onerm: 102,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 95),
        ]

        DisplayedView {
            Exercisechart(
                type: Exercisedatatype.volume,
                analysisedlist: analysisedlist
            )
            .frame(height: 200)
        }
    }
}

struct Exercisechart: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var model: Exercisechartmodel

    var type: Exercisedatatype

    init(type: Exercisedatatype,
         analysisedlist: [Analysisedexercise]) {
        self.type = type
        model = Exercisechartmodel(type: type, analysisedlist: analysisedlist)
    }

    @State var location: CGPoint?

    var baselineview: some View {
        HStack {
            if model._ymin != model._ymax {
                if let _min = model._yminstring(preference.ofweightunit) {
                    LocaleText(_min)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 4).bold())
                        .frame(width: 50)
                        .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
                }

                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .frame(height: 1)
                    .foregroundColor(NORMAL_LIGHTEST_GRAY_COLOR)
            }
        }
        .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
    }

    var uplineview: some View {
        HStack {
            if let _max = model._ymaxstring(preference.ofweightunit) {
                LocaleText(_max)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 4).bold())
                    .frame(width: 50)
                    .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
            }

            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                .frame(height: 1)
                .foregroundColor(NORMAL_LIGHTEST_GRAY_COLOR)
        }
        .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
    }

    var xlineview: some View {
        HStack(spacing: 0) {
            SPACE.frame(width: 40)

            SPACE.frame(width: model.expectwidth)

            LocaleText(model.xlist.last ?? "")

            SPACE
        }
        .foregroundColor(NORMAL_GRAY_COLOR)
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 4).bold())
    }

    var ofylast: String {
        if let ylast = model._ylast {
            if type == .sets {
                return String(format: "%.0f", ylast)
            } else {
                let ret: Double = Weight(value: ylast, weightunit: .kg)
                    .transformedto(weightunit: preference.ofweightunit)

                return "\(String(format: "%.1f", ret)) \(preference.ofweightunit)"
            }
        }
        return ""
    }

    var descriptionview: some View {
        VStack(spacing: 5) {
            HStack {
                SPACE

                LocaleText(ofylast)
                    .font(.system(size: 25).bold())
                    .foregroundColor(NORMAL_LIGHTER_COLOR)

                SPACE
            }

            LocaleText("current")
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
        .foregroundColor(NORMAL_GRAY_COLOR)
    }

    var lineview: some View {
        ZStack {
            GeometryReader {
                reader in

                let height: CGFloat = reader.size.height

                ZStack {
                    uplineview
                        .position(x: UIScreen.width / 2, y: height * 0.1)

                    baselineview
                        .position(x: UIScreen.width / 2, y: height * 0.7)

                    xlineview
                        .position(x: UIScreen.width / 2, y: height * 1.15)
                }

                // ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                    HStack {
                        Chart(data: model.ylist)
                            .chartStyle(
                                ColumnChartStyle(
                                    column: Capsule()
                                        .foregroundColor(preference.themeprimarycolor),
                                    spacing: 2
                                )
                            )
                            .frame(width: model.expectwidth)

                        SPACE
                    }
                }
                .padding(.leading, 60)
                // }
                // .padding(.leading, 60)
            }
        }
    }

    var body: some View {
        VStack(spacing: 30) {
            descriptionview

            if model.ylist.isEmpty {
                Emptycontentpanel()
            } else {
                lineview
            }
        }
        .animationsDisabled()
    }
}

extension Exercisechart {
    func updateLocation(_ location: CGPoint) {
        self.location = location
    }
}

/*

 var volumelist: [Double] {
     let analysisedlist = analysisedlist
     let _volumelist: [Double] = analysisedlist.map({ $0.volume })
     if _volumelist.isEmpty {
         return []
     }

     let _min: Double = _volumelist.min() ?? 0.0
     let _max: Double = _volumelist.max() ?? 1.0

     return _volumelist.map({
         let factor = ($0 - _min) / (_max - _min)
         return (0.8 + (0.2 * factor))

     })
 }

 let volumelist = volumelist
 let width = reader.size.width
 let itemwidth = count == 0 ? width : (width / CGFloat(count))

 let floatx = CGFloat(indexof(itemwidth)) * itemwidth
 let floaty = reader.size.height / 2

 VStack(alignment: .center, spacing: 0) {
     let idx = indexof(itemwidth)
     let _a = analysisedlist[idx]
     let leftx = decidex(floatx, width: width)

     VStack(alignment: .leading, spacing: 0) {
         Text(_a.workday.systemedyearmonthdate)
             .font(.system(size: DEFINE_FONT_SMALL_SIZE - 3).bold())
             .foregroundColor(NORMAL_GRAY_COLOR)

         Text(_a.displayvolume)
             .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
             .foregroundColor(NORMAL_LIGHTER_COLOR)
             .lineLimit(2)
             .minimumScaleFactor(0.01)
     }
     .frame(width: 60)
     .offset(x: leftx)

     Image("upArrow")
         .renderingMode(.template)
         .resizable()
         .frame(width: 14, height: 15)
         .rotationEffect(Angle(degrees: 180))
         .foregroundColor(NORMAL_GREEN_COLOR)
         .offset(y: 2)

     SPACE
 }
 .position(x: floatx, y: floaty)

 func indexof(_ itemwidth: CGFloat) -> Int {
     if let _l = location {
         let _rounded = lroundf(Float(_l.x / itemwidth))
         return _rounded - 1
     }
     return count
 }

 func decidex(_ x: CGFloat, width: CGFloat) -> CGFloat {
     if x < 35 {
         return 25
     }

     if x > width - 45 {
         return -35
     }

     return 0
 }

 var volumelineview: some View {
     ZStack {
         GeometryReader {
             reader in

             VStack {
                 SPACE.frame(height: 50)

                 Chart(data: volumelist)
                     .chartStyle(
                         LineChartStyle(.quadCurve,
                                        lineColor: .blue, lineWidth: 2)

                     )
                     .frame(width: width)
                     .onTouch(perform: updateLocation)
                     .contentShape(Rectangle())
             }
         }
     }
 }

 if analysisedlist.count > 1 {
     HStack {
         Text(analysisedlist.first?.workday.systemedyearmonthdate ?? "")

         SPACE

         Text(analysisedlist.last?.workday.systemedyearmonthdate ?? "")
     }
     .font(.system(size: DEFINE_FONT_SMALL_SIZE - 3).bold())
     .foregroundColor(NORMAL_GRAY_COLOR)
 }

 */
