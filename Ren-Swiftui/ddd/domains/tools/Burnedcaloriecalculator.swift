//
//  Burnedcaloriecalculator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/22.
//

import SwiftUI

struct Burnedcaloriecalculator_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Burnedcaloriecalculator(present: .constant(true))
        }
    }
}

struct Burnedcaloriecalculator: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool

    init(present: Binding<Bool>) {
        _present = present

        log("init burned calorie view")
    }

    var uptab: some View {
        VStack {
            UptabHeaderView(present: $present) {
            }
            .padding(.horizontal)
            .background(
                NORMAL_UPTAB_BACKGROUND_COLOR
            )

            SPACE
        }
    }

    @State var weight: String = ""
    var weightkg: Double {
        let waistnum = Double(weight) ?? 0.0
        return Weight(value: waistnum, weightunit: metricorenglish.weightunit).askgweight
    }

    @State var age: String = ""
    var agenumber: Double {
        Double(age) ?? 0.0
    }

    @State var minuts: String = ""
    var minutsnumber: Double {
        Double(minuts) ?? 0.0
    }

    @State var heartrate: String = ""
    var heartratenumber: Double {
        Double(heartrate) ?? 0.0
    }

    var ret: String {
        var ret: Double = 0.0

        if !weight.isEmpty && !age.isEmpty && !minuts.isEmpty && !heartrate.isEmpty {
            if gender == .male {
                ret =
                    minutsnumber * (0.6309 * heartratenumber + 0.1988 * weightkg + 0.2017 * agenumber - 55.0969) / 4.184
            } else {
                ret =
                    minutsnumber * (0.4472 * heartratenumber - 0.1263 * weightkg + 0.074 * agenumber - 20.4022) / 4.184
            }
        }

        return String(format: "%.1f", ret)
    }

    var retview: some View {
        VStack {
            Text(ret)
                .font(.system(size: 30).bold())
                .padding(3)

            LocaleText("kcal", lowercase: true)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(NORMAL_GRAY_COLOR)
        }
        .frame(width: UIScreen.width - 50, height: 120)
    }

    var selectionview: some View {
        VStack(spacing: 15) {
            genderselectview
            weightandageview
            heartrateanddurarionview
        }
        .padding(.horizontal)
    }

    @State var metricorenglish: Englishormetric = .metric
    var englishormetricview: some View {
        Englishormetricpicker(picked: $metricorenglish)
    }

    @State var gender: Gender = .male
    var genderselectview: some View {
        HStack(spacing: MIDDLE_SPACING) {
            Answerselection(
                answer: Gender.male.rawValue,
                answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                focused: gender == .male,
                height: NORMAL_ANSWER_INPUT_HEIGHT
            )
            .contentShape(Rectangle())
            .onTapGesture {
                gender = .male
            }

            Answerselection(
                answer: Gender.female.rawValue,
                answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                focused: gender == .female,
                height: NORMAL_ANSWER_INPUT_HEIGHT
            )
            .contentShape(Rectangle())
            .onTapGesture {
                gender = .female
            }
        }
    }

    var weightandageview: some View {
        HStack(spacing: MIDDLE_SPACING) {
            Answernumberfield(title: preference.language("currentweight"),
                              answer: $weight,
                              answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                              descriptor: metricorenglish.weightunit.rawValue,
                              alwaysshowdescriptor: true
            )

            let agelabel = preference.language("age")
            Answernumberfield(numbertype: .integer, title: agelabel, answer: $age, descriptor: agelabel)
        }
    }

    var heartrateanddurarionview: some View {
        HStack {
            Answernumberfield(numbertype: .integer, title: preference.language("duration"), answer: $minuts, descriptor: "min", alwaysshowdescriptor: true)
            Answernumberfield(numbertype: .integer, title: preference.language("heartrate"), answer: $heartrate, descriptor: "bpm", alwaysshowdescriptor: true)
        }
    }

    var contenview: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                SPACE.frame(height: MIN_UP_TAB_HEIGHT)

                Question("burnedcaloriecalculator")

                LocaleText("burnedcaloriecalculatorcription", usefirstuppercase: false, linelimit: 10)
                    .foregroundColor(NORMAL_GRAY_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
                    .padding()
                    .frame(height: 100)

                englishormetricview

                retview.padding(.vertical)

                selectionview

                SPACE.frame(height: UIScreen.height / 2)
            }
        }
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            contenview

            uptab
        }
        .onTapGesture {
            endtextediting()
        }
        .ignoresSafeArea(.keyboard)
    }
}
