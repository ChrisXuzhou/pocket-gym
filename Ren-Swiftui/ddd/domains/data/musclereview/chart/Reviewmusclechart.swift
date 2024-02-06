//
//  Reviewmusclechartcontent.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/10.
//

import SwiftUI
import SwiftUIPager

struct Reviewmusclechart: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var model: Activitymuscledatachartmodel

    init(lastdays: Int, analysisedexercises: [Analysisedexercisewrapper]) {
        model = Activitymuscledatachartmodel(lastdays: lastdays, analysisedexercises: analysisedexercises)

        UISegmentedControl.appearance().backgroundColor = UIColor(NORMAL_GRAY_COLOR.opacity(0.6))
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                selectorpanel

                selectedcontent

                SPACE
            }
        }
    }
}

extension Reviewmusclechart {
    var selectorpanel: some View {
        VStack(spacing: 0) {
            SPACE.frame(height: 15)

            HStack(spacing: 0) {
                ForEach(Reviewmuscledatatype.allCases, id: \.self) {
                    datatype in

                    Reviewmusclechartselector(
                        description: datatype.rawValue,
                        selected: model.selectedtype == datatype
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            model.selectedtype = datatype
                        }
                    }
                }
            }
            .frame(width: CHART_MUSCLE_IND_FULL_WIDTH, height: 22)
            .background(
                NORMAL_BG_COLOR.ignoresSafeArea()
            )

            ZStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    SPACE

                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(preference.theme)
                        .frame(width: 25, height: 2)

                    SPACE
                }
                .frame(width: CHART_MUSCLE_IND_WIDTH)
                .position(x: CHART_MUSCLE_IND_WIDTH / 2)
                .offset(x: 0 + CGFloat(model.selectedtype.index) * CHART_MUSCLE_IND_WIDTH, y: 0)
            }
            .frame(height: 2)
        }
    }

    var selectedcontent: some View {
        Reviewmusclechartcontent(
            type: model.selectedtype,
            lastdays: model.lastdays,
            analysisedexercises: model.analysisedexercises
        )
    }
}

struct Reviewmusclechartcontent: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var page: Page
    @ObservedObject var model: Reviewmusclechartcontentmodel

    init(type: Reviewmuscledatatype,
         lastdays: Int,
         analysisedexercises: [Analysisedexercisewrapper]) {
        let model = Reviewmusclechartcontentmodel(
            type: type,
            lastdays: lastdays,
            analysisedlist: analysisedexercises)

        self.model = model

        var idx: Int = 0
        if model.ylist.count > 1 {
            idx = model.ylist.count - 1

            for i in (0 ... idx).reversed() {
                if model.ylist[i] > 0.0 {
                    idx = i
                    break
                }
            }
        }

        // _page = StateObject(wrappedValue: Page.withIndex(idx))
        page = Page.withIndex(idx)
    }

    var textcolor: Color = NORMAL_LIGHTER_COLOR
    var lighttextcolor: Color = NORMAL_LIGHTER_COLOR.opacity(0.6)

    var chartindicator: some View {
        VStack {
            let _idx = page.index

            if !model.ydescriptionlist.isEmpty {
                VStack(spacing: 3) {
                    if let _v = model.ydescriptionlist[_idx] {
                        if !_v.isEmpty {
                            HStack(alignment: .lastTextBaseline, spacing: 3) {
                                LocaleText(_v)
                                    .font(
                                        .system(size: DEFINE_FONT_BIG_SIZE)
                                            .weight(.heavy)
                                    )

                                if model.type == .volume {
                                    LocaleText(preference.ofweightunit.name)
                                        .font(
                                            .system(size: DEFINE_FONT_SMALL_SIZE)
                                                .weight(.heavy)
                                        )
                                }
                            }
                        }
                    }

                    if let _x: Daywrapper = model.days[_idx] {
                        if let _day = _x.day {
                            LocaleText(_day.displayedyearmonthdate)
                                .font(
                                    .system(size: DEFINE_FONT_SMALL_SIZE)
                                        .weight(.heavy)
                                )
                                .foregroundColor(
                                    lighttextcolor
                                )
                        }
                    }
                }
            }
        }
        .foregroundColor(textcolor)
        .frame(height: 60)
    }

    var chartcontent: some View {
        GeometryReader {
            reader in

            HStack {
                let height: CGFloat = reader.size.height > 60 ? reader.size.height - 60 : reader.size.height
                let ratio: CGFloat = model.type.ratio

                Pager(page: page, data: 0 ..< model.ylist.count, id: \.self) {
                    idx in

                    VStack(spacing: 0) {
                        let y = model.ylist[idx] * ratio
                        let offset = (abs(1 - y) * height) / 2

                        ZStack {
                            Rectangle()
                                .cornerRadius(20, corners: [.topLeft, .topRight])
                                .frame(width: CHART_ITEM_GRAPH_WIDTH, height: y * height)
                                .foregroundColor(preference.theme)
                                .offset(y: offset)
                        }
                        .frame(height: height)
                        .contentShape(Rectangle())

                        let date: Daywrapper = model.days[idx]

                        VStack {
                            if let _date: Date = date.day {
                                VStack {
                                    LocaleText("\(_date.day)")
                                        .font(
                                            .system(
                                                size: DEFINE_FONT_SMALLER_SIZE - 2,
                                                design: .rounded
                                            )
                                            .weight(.heavy)
                                        )

                                    LocaleText("\(_date.shortweek)", uppercase: true)
                                        .font(
                                            .system(
                                                size: DEFINE_FONT_SMALLER_SIZE - 2,
                                                design: .rounded
                                            )
                                            .weight(.heavy)
                                        )
                                        .foregroundColor(lighttextcolor)

                                    SPACE
                                }

                            } else {
                                VStack {
                                    LocaleText("\(date.emtydays.asemptydays)")
                                        .font(
                                            .system(
                                                size: DEFINE_FONT_SMALLER_SIZE - 2,
                                                design: .rounded
                                            )
                                            .weight(.heavy)
                                        )
                                        .foregroundColor(lighttextcolor)
                                }
                            }

                            SPACE
                        }
                        .padding(.vertical, 2)
                        .foregroundColor(textcolor)
                        .frame(width: CHART_ITEM_WIDTH, height: 35)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            page.update(.new(index: idx))
                        }
                    }
                }
                .alignment(.center)
                .preferredItemSize(CGSize(width: CHART_ITEM_WIDTH, height: 80))
                .horizontal()
                .itemSpacing(0)
                .sensitivity(.high)
                .multiplePagination()
                .interactive(opacity: 0.15)
            }
        }
    }

    var overlayedtagview: some View {
        VStack {
            SPACE

            if !model.days.isEmpty {
                ZStack {
                    HStack {
                        SPACE

                        Image("upArrow")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(preference.theme)

                        SPACE
                    }
                }
                .frame(height: 25)
                .offset(y: 10)
            }
        }
    }

    var summaryview: some View {
        ZStack {
            VStack(spacing: 0) {
                chartindicator
                    .padding(.top)

                SPACE

                chartcontent
            }

            overlayedtagview
        }
        .frame(height: 230)
        .background(
            NORMAL_BG_COLOR.ignoresSafeArea()
        )
    }

    var summarydetailsview: some View {
        LazyVStack(spacing: 60) {
            let _idx = page.index

            if !model.days.isEmpty {
                if let day = model.days[_idx].day {
                    if let analysisedlist = model.datestr2analysisedlist[day.systemedyearmonthdate] {
                        ForEach(0 ..< analysisedlist.count, id: \.self) {
                            idx in

                            let analysised = analysisedlist[idx]
                            Reviewworkoutpanel(
                                analysised: analysised,
                                showexercisedatalink: true,
                                showexercise: true
                            )
                        }
                    }
                }
            }

            SPACE.frame(height: 50)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            summaryview

            summarydetailsview
        }
    }
}

let CHART_MUSCLE_IND_FULL_WIDTH: CGFloat = UIScreen.width
let CHART_MUSCLE_IND_WIDTH: CGFloat = UIScreen.width / CGFloat(Reviewmuscledatatype.allCases.count)

struct Reviewmusclechartselector: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var description: String
    var selected: Bool

    var body: some View {
        VStack {
            SPACE

            LocaleText(description,
                       usefirstuppercase: true)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE, design: .rounded).bold())
                .foregroundColor(
                    selected ?
                        NORMAL_LIGHTER_COLOR : NORMAL_LIGHT_GRAY_COLOR
                )
                .foregroundColor(selected ? .white : .white.opacity(0.6))

            SPACE.frame(height: 5)
        }
        .frame(width: CHART_MUSCLE_IND_WIDTH, height: 22)
    }
}
