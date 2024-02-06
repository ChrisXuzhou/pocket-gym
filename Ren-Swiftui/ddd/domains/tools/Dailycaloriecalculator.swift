//
//  Dailycaloriecalculator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/22.
//

import SwiftUI
struct Dailycaloriecalculator_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Dailycaloriecalculator(present: .constant(true))
        }
    }
}

struct Dailycaloriecalculator: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool

    init(present: Binding<Bool>) {
        _present = present

        log("init 1rm view")
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

    @State var height: String = ""
    var heightcm: Double {
        let heightnum = Double(height) ?? 0.0
        return Length(value: heightnum, lengthunit: metricorenglish.lengthunit).ascmlenth
    }

    @State var weight: String = ""
    var weightkg: Double {
        let waistnum = Double(weight) ?? 0.0
        return Weight(value: waistnum, weightunit: metricorenglish.weightunit).askgweight
    }

    @State var age: String = ""
    var agenumber: Int {
        Int(age) ?? 0
    }

    @State var activitylevel: Activitylevel = Activitylevel.activityl0

    var s: Double {
        if gender == .male {
            return 5
        }
        return -161
    }

    var ret: String {
        var ret: Double = 0.0

        if !weight.isEmpty && !height.isEmpty {
            ret = Double(10) * weightkg + 6.25 * heightcm - Double(5 * agenumber) + s
            ret = ret * activitylevel.ratio
        }

        return String(format: "%.1f", ret)
    }

    var retview: some View {
        VStack {
            Text(ret)
                .font(.system(size: 30).bold())
                .padding(3)

            LocaleText("kcalperday", lowercase: true)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(NORMAL_GRAY_COLOR)
                
        }
        .frame(width: UIScreen.width - 50, height: 120)
    }

    var selectionview: some View {
        VStack(spacing: 15) {
            genderselectview
            weightandheightview
            ageview
            exerciselevelview
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

    var weightandheightview: some View {
        HStack(spacing: MIDDLE_SPACING) {
            Answernumberfield(title: preference.language("currentweight"),
                              answer: $weight,
                              answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                              descriptor: metricorenglish.weightunit.rawValue,
                              alwaysshowdescriptor: true
            )

            Answernumberfield(title: preference.language("height"),
                              answer: $height,
                              answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                              descriptor: metricorenglish.lengthunit.rawValue,
                              alwaysshowdescriptor: true
            )
        }
    }

    var ageview: some View {
        HStack {
            let agelabel = preference.language("age")
            Answernumberfield(numbertype: .integer, title: agelabel, answer: $age, descriptor: agelabel)
            Answernumberfield(numbertype: .integer, title: agelabel, answer: $age, descriptor: agelabel).hidden()
        }
    }

    @State var showselector = false

    var exerciselevelview: some View {
        HStack {
            Answerinput(answer: activitylevel.rawValue, focused: showselector)
                .contentShape(Rectangle())
                .onTapGesture {
                    endtextediting()
                    showselector = true
                }
        }
    }

    var contenview: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                SPACE.frame(height: MIN_UP_TAB_HEIGHT)

                Question("dailycaloriecalculator")

                LocaleText("dailycaloriecalculatorcription", usefirstuppercase: false, linelimit: 10)
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
