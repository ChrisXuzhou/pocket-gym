//
//  Reviewworkoutsview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import SwiftUI
import SwiftUIPager

struct Reviewworkoutsview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ExerciseView(exercise: prepareexercise())
        }
    }
}

let CHART_ITEM_WIDTH: CGFloat = 35
let CHART_ITEM_GRAPH_WIDTH: CGFloat = 30

let WORKOUT_IND_FULL_WIDTH: CGFloat = UIScreen.width
let WORKOUT_IND_WIDTH: CGFloat = WORKOUT_IND_FULL_WIDTH / CGFloat(Exercisedatatype.allCases.count)

struct Reviewworkoutsview: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var model: Reviewworkoutsviewmodel

    var title: String
    var showexerciselink: Bool
    var exercisedef: Newdisplayedexercise

    init(exercisedef: Newdisplayedexercise,
         selectedtype: Exercisedatatype = .onerm) {
        title = exercisedef.realname
        self.exercisedef = exercisedef
        showexerciselink = false

        let analysisedexercises =
            AppDatabase.shared.querylast20analysisedexercise(exerciseid: exercisedef.exercise.exerciseid!)
                .map({ Analysisedexercisewrapper($0) })
                .sorted { l, r in
                    l.analysis.id! < r.analysis.id!
                }

        model = Reviewworkoutsviewmodel(analysisedexercises: analysisedexercises, selectedtype: selectedtype)
    }

    var body: some View {
        VStack(spacing: 0) {
            SPACE.frame(height: 20)

            selectorpanel

            selecteddataview

            SPACE
        }
    }
}

extension Reviewworkoutsview {
    var uptab: some View {
        HStack {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }

            SPACE

            LocaleText(title)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .padding(0)

            SPACE

            SPACE.frame(width: 30)
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.leading)
    }
}

extension Reviewworkoutsview {
    var selectorpanel: some View {
        VStack(spacing: 0) {
            SPACE.frame(height: 7)

            HStack(spacing: 0) {
                ForEach(Exercisedatatype.allCases, id: \.self) {
                    datatype in

                    Reviewworkoutsviewselector(
                        description: datatype.name,
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
            .frame(width: WORKOUT_IND_FULL_WIDTH, height: 22)
            .background(
                NORMAL_BG_COLOR.ignoresSafeArea()
            )

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(NORMAL_LIGHT_GRAY_COLOR.opacity(0.3))
                    .frame(height: 1)

                HStack(spacing: 0) {
                    SPACE

                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(preference.theme)
                        .frame(width: 25, height: 2)

                    SPACE
                }
                .frame(width: WORKOUT_IND_WIDTH)
                .position(x: WORKOUT_IND_WIDTH / 2)
                .offset(x: 0 + CGFloat(model.selectedtype.index) * WORKOUT_IND_WIDTH, y: 0)
            }
            .frame(width: WORKOUT_IND_FULL_WIDTH, height: 2)
        }
    }

    var selecteddataview: some View {
        Reviewworkoutsviewcontent(
            exercise: exercisedef,
            type: model.selectedtype,
            analysisedexercises: model.analysisedexercises
        )
    }
}

struct Reviewworkoutsviewselector: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var description: String
    var selected: Bool

    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE
    var focusedcolor: Color = NORMAL_LIGHTER_COLOR
    var unfocusedcolor: Color = NORMAL_LIGHT_BUTTON_COLOR

    var body: some View {
        VStack {
            SPACE

            LocaleText(
                description,
                usefirstuppercase: false, tracking: 0.3
            )
            .font(.system(size: fontsize, design: .rounded).bold()) //
            .foregroundColor(selected ? focusedcolor : unfocusedcolor)

            SPACE.frame(height: 5)
        }
        .frame(width: WORKOUT_IND_WIDTH, height: 22)
    }
}

struct Reviewworkoutsviewcontent: View {
    @EnvironmentObject var preference: PreferenceDefinition

    let exercise: Newdisplayedexercise?
    @StateObject var page: Page
    @ObservedObject var model: Activitychartcontentmodel

    var textcolor: Color = NORMAL_LIGHTER_COLOR
    var lighttextcolor: Color = NORMAL_LIGHTER_COLOR.opacity(0.6)

    init(exercise: Newdisplayedexercise?,
         type: Exercisedatatype,
         lastdays: Int = 90,
         analysisedexercises: [Analysisedexercisewrapper]) {
        self.exercise = exercise

        let model = Activitychartcontentmodel(type: type,
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

        _page = StateObject(wrappedValue: Page.withIndex(idx))
    }

    var chartindicator: some View {
        VStack(spacing: 3) {
            let _idx = page.index

            if !model.ydescriptionlist.isEmpty {
                if let _v: String = model.ydescriptionlist[_idx] {
                    if !_v.isEmpty {
                        HStack(alignment: .lastTextBaseline, spacing: 3) {
                            LocaleText(_v)
                                .font(
                                    .system(size: DEFINE_FONT_BIG_SIZE)
                                        .weight(.heavy)
                                )

                            if model.type != .sets {
                                LocaleText(preference.ofweightunit.name)
                                    .font(
                                        .system(size: DEFINE_FONT_SMALL_SIZE)
                                            .weight(.heavy)
                                    )
                            }
                        }

                        if let _x = model.days[_idx].day {
                            LocaleText(_x.displayedyearmonthdate)
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
                                .cornerRadius(10, corners: [.topLeft, .topRight])
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

    var summarydetailsview: some View {
        LazyVStack(spacing: 60) {
            let _idx = page.index

            if !model.days.isEmpty {
                /*

                     // Emptycontentpanel()
                 } else {

                 */
                let daywrapper = model.days[_idx]

                if let day: Date = daywrapper.day {
                    if let analysisedlist = model.datestr2analysisedlist[day.systemedyearmonthdate] {
                        ForEach(0 ..< analysisedlist.count, id: \.self) {
                            idx in

                            let analysised = analysisedlist[idx]
                            Reviewworkoutpanel(
                                analysised: analysised,
                                showexercisedatalink: false
                            )
                        }
                    } else {
                        LocaleText(day.displayedyearmonthdate)
                            .font(
                                .system(size: DEFINE_FONT_BIG_SIZE)
                                    .weight(.heavy)
                            )
                            .foregroundColor(
                                lighttextcolor
                            )
                            .padding(.top, 30)

                        RestoffView()
                    }
                } else {
                    RestoffView()
                }
            }

            SPACE.frame(height: 50)
        }
    }

    var _body: some View {
        VStack(spacing: 0) {
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

            summarydetailsview.padding(.vertical)
        }
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            _body
        }
    }
}

extension Int {
    var asemptydays: String {
        if self > 10 {
            return "10+"
        }

        return "\(self)"
    }
}

/*

 var exercisepanel: some View {
     VStack {
         let width = UIScreen.width
         let height = UIScreen.width * (2 / 3)
         ZStack {
             NORMAL_BG_VIDEO_COLOR

              exercisemodel
                  .videoview
                  .frame(width: width, height: height)
                  .id(exercisemodel.exercise.exercise.ident)

             if showexerciselink {
                 VStack {
                     SPACE
                     HStack {
                         SPACE

                         NavigationLink {
                             ExercisedetailView(exercise: exercisemodel.exercise)
                                 .navigationBarHidden(true)
                                 .navigationBarBackButtonHidden(true)
                         } label: {
                             Image("info")
                                 .renderingMode(.template)
                                 .resizable()
                                 .frame(width: 20, height: 20, alignment: .center)
                                 .aspectRatio(contentMode: .fill)
                                 .foregroundColor(preference.theme)
                                 .frame(width: 40, height: 40, alignment: .center)
                                 .background(
                                     Circle()
                                         .foregroundColor(NORMAL_LIGHT_GRAY_COLOR.opacity(0.2))
                                 )
                                 .contentShape(Rectangle())
                         }
                         .isDetailLink(false)
                     }
                 }
                 .padding()
             }
         }
         .frame(width: width, height: height)

     }
 }

 */

/*

      ScrollView(.vertical, showsIndicators: false) {

 }
  */

/*
 var body: some View {
     ZStack {
         NORMAL_BG_COLOR.ignoresSafeArea()

         VStack(spacing: 0) {
             uptab
                 .background(
                     NORMAL_BG_COLOR.ignoresSafeArea()
                 )

             ScrollView(.vertical, showsIndicators: false) {
                 VStack(spacing: 0) {
                     exercisepanel
                         .padding(.top, 10)

                     SPACE.frame(height: 20)

                     selectorpanel

                     selecteddataview

                     SPACE
                 }
             }

             SPACE

             // end of scroll
         }
     }
 }

 */
