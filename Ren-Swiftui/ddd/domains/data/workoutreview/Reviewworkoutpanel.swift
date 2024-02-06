//
//  Reviewworkoutpanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import SwiftUI

struct Reviewworkoutpanel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    let analysised: Analysisedexercisewrapper
    var showexercisedatalink: Bool = false
    var showexercise: Bool = false

    var dateview: some View {
        HStack {
            SPACE

            LocaleText(analysised.analysis.workday.displayedonlytime)

            SPACE
        }
        .font(.system(size: DEFINE_FONT_BIG_SIZE + 4).bold())
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(height: 60)
    }

    var body: some View {
        VStack(spacing: 0) {

            dateview

            Rectangle()
                .frame(height: 1)
                .foregroundColor(
                    NORMAL_LIGHT_GRAY_COLOR.opacity(0.3)
                )
                .padding(.horizontal)

            datapanel

            Rectangle()
                .frame(height: 1)
                .foregroundColor(
                    NORMAL_LIGHT_GRAY_COLOR.opacity(0.3)
                )
                .padding(.horizontal)

            relatedbatchpanel
        }
        .padding(.bottom, 10)
        .background(NORMAL_BG_CARD_COLOR)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 15)
        .padding(10)
        .animationsDisabled()
    }
}

extension Reviewworkoutpanel {
    var relatedbatchpanel: some View {
        VStack {
            if let _batch = analysised.analysis.relatedbatch {
                Exerciseresulteachbatchlabel(
                    batch: _batch,
                    showexerciseinfo: showexercise,
                    showdate: false,
                    showlink: showexercisedatalink
                )
                .padding(.horizontal, 5)
            }
        }
    }
}

extension Reviewworkoutpanel {
    var onermpanel: some View {
        HStack {
            let unitname: String = preference.ofweightunit.name
            let value = Weight(value: analysised.analysis.onerm, weightunit: .kg).transformedto(weightunit: preference.ofweightunit)
            let valuestr = "\(String(format: "%.1f", value))\(unitname)"

            ReviewworkoutpanelValue(
                description: Exercisedatatype.onerm.name,
                value: valuestr
            )
        }
    }

    var maxpanel: some View {
        HStack {
            let unitname: String = preference.ofweightunit.name
            let value = Weight(value: analysised.analysis.maxweight, weightunit: .kg).transformedto(weightunit: preference.ofweightunit)
            let valuestr = "\(String(format: "%.1f", value))\(unitname)"

            ReviewworkoutpanelValue(
                description: Exercisedatatype.max.name,
                value: valuestr
            )
        }
    }

    var volumepanel: some View {
        HStack {
            let unitname: String = preference.ofweightunit.name
            let value = Weight(value: analysised.analysis.volume, weightunit: .kg).transformedto(weightunit: preference.ofweightunit)
            let valuestr = "\(String(format: "%.1f", value))\(unitname)"

            ReviewworkoutpanelValue(
                description: Exercisedatatype.volume.name,
                value: valuestr
            )
        }
    }

    var setspanel: some View {
        HStack {
            let value: Int = analysised.analysis.sets
            let valuestr = "\(value)"

            ReviewworkoutpanelValue(
                description: Exercisedatatype.sets.name,
                value: valuestr
            )
        }
    }

    var datapanel: some View {
        HStack(spacing: 0) {
            let width = (UIScreen.width - 50) / 10
            // .frame(width: (UIScreen.width - 50) / 4, height: 70)

            onermpanel
                .frame(width: width * 3)
            maxpanel
                .frame(width: width * 3)
            volumepanel
                .frame(width: width * 3)
            setspanel
                .frame(width: width)
            SPACE
        }
        .padding(.leading)
        .frame(height: 70)
    }
}

struct ReviewworkoutpanelValue: View {
    var description: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LocaleText(description, usefirstuppercase: false)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1, design: .rounded).bold())
                .foregroundColor(NORMAL_BUTTON_COLOR)

            SPACE

            HStack(spacing: 0) {
                LocaleText(value)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
                    .foregroundColor(
                        NORMAL_LIGHTER_COLOR
                    )

                SPACE
            }
        }
        .padding(.vertical)
    }
}
