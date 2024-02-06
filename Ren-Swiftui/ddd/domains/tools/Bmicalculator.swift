//
//  Bmicalculator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/22.
//

import SwiftUI

struct Bmicalculator_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Bmicalculator(present: .constant(true))
        }
    }
}

struct Bmicalculator: View {
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
    
    @State var weight: String = ""
    var weightkg: Double {
        let weightnum = Double(weight) ?? 0.0
        return Length(value: weightnum, lengthunit: metricorenglish.lengthunit).ascmlenth
    }

    @State var height: String = ""
    var heightcm: Double {
        let heightnum = Double(height) ?? 0.0
        return Length(value: heightnum, lengthunit: metricorenglish.lengthunit).ascmlenth
    }

    var ret: String {
        var percent: Double = 0.0
        if !weight.isEmpty && !height.isEmpty {
            let _height = heightcm / 100
            percent = (weightkg / (_height * _height))
        }

        return String(format: "%.1f", percent)
    }

    var retview: some View {
        VStack(spacing: 10) {
            HStack(alignment: .lastTextBaseline) {
                Text(ret)
                    .font(.system(size: 30).bold())
            }
        }
        .frame(width: UIScreen.width - 50, height: 60)
    }

    @State var showselector = false

    var selectionview: some View {
        VStack(spacing: 15) {
            // genderselectview
            
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

    var contenview: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                SPACE.frame(height: MIN_UP_TAB_HEIGHT)

                Question("bmicalculator")

                LocaleText("bmicalculatorcription", usefirstuppercase: false, linelimit: 10)
                    .foregroundColor(NORMAL_GRAY_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
                    .padding(.horizontal)
                    .padding()
                    .frame(height: 100)

                englishormetricview
                    .padding(.top, 5)

                retview
                    .padding(.vertical, 35)

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
