//
//  DatamuscleView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/7.
//


import SwiftUI

struct Muscleradardetailview: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    /*
     * variables
     */
    @StateObject var model: Muscleradardetailmodel

    init(_ muscleid: String, days: Int, workouttimes: Int) {
        _model = StateObject(wrappedValue: Muscleradardetailmodel(muscleid, days: days, workouttimes: workouttimes))
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                uptabheader

                contentview

                SPACE
            }
        }
        .environmentObject(model)
    }
}

extension Muscleradardetailview {
    var uptabheader: some View {
        HStack {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }
            .padding(.trailing, 10)

            SPACE

            Text("\(preference.language(model.muscleid)), \(preference.languagewithplaceholder("lastdays", value: "\(model.days)"))")
                .multilineTextAlignment(.center)
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            SPACE.frame(width: 30)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
    }

    var contentview: some View {
        VStack(spacing: 0) {
            selectorlabel

            LOCAL_DIVIDER

            content

            SPACE
        }
    }

    var selectorlabel: some View {
        HStack(spacing: 0) {
            ForEach(Muscleradardetailtype.allCases, id: \.self) {
                type in

                Reviewmuscleanalysisedmenu(
                    description: type.rawValue,
                    selected: model.pagedto == type
                )
                .onTapGesture {
                    model.pagedto = type

                    DispatchQueue.global().async {
                        var appcache = Appcache(cachekey: MUSCLE_RADAR_DETAIL_TYPE_KEY, cachevalue: type.rawValue)
                        try! AppDatabase.shared.saveappcache(&appcache)
                    }
                }
            }
        }
    }

    var content: some View {
        VStack {
            if model.pagedto == .summary {
                Muscleradarsummaryview()
            } else if model.pagedto == .history {
                Reviewmusclechart(
                    lastdays: model.days,
                    analysisedexercises: model.analysises
                )
            }
        }
    }
}

struct Reviewmuscleanalysisedmenu: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var description: String
    var selected: Bool

    var body: some View {
        VStack(spacing: 0) {
            SPACE

            LocaleText(description, usefirstuppercase: false)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(selected ? preference.theme : NORMAL_BUTTON_COLOR)

            SPACE
        }
        .frame(width: UIScreen.width / CGFloat(Muscleradardetailtype.allCases.count),
               height: 50
        )
    }
}
