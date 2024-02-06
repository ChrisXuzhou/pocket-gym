//
//  Fatpercentcalculator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/21.
//

import SwiftUI
import SwiftUIPager

struct Fatpercentcalculator_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Fatpercentcalculator(present: .constant(true))
        }
    }
}

struct Fatpercentcalculator: View {
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

    @State var waist: String = ""
    var waistcm: Double {
        let waistnum = Double(waist) ?? 0.0
        return Length(value: waistnum, lengthunit: metricorenglish.lengthunit).ascmlenth
    }

    @State var neck: String = ""
    var neckcm: Double {
        let necknum = Double(neck) ?? 0.0
        return Length(value: necknum, lengthunit: metricorenglish.lengthunit).ascmlenth
    }

    @State var hip: String = ""
    var hipcm: Double {
        let hipnum = Double(hip) ?? 0.0
        return Length(value: hipnum, lengthunit: metricorenglish.lengthunit).ascmlenth
    }

    var ret: String {
        var percent: Double = 0.0

        if gender == .male && !waist.isEmpty && !neck.isEmpty && !height.isEmpty {
            percent = 495 / (1.0324 - 0.19077 * log10(waistcm - neckcm) + 0.15456 * log10(heightcm)) - 450
        } else if gender == .female && !waist.isEmpty && !neck.isEmpty && !height.isEmpty && !hip.isEmpty {
            percent = 495 / (1.29579 - 0.35004 * log10(waistcm + hipcm - neckcm) + 0.22100 * log10(heightcm)) - 450
        }

        return String(format: "%.1f", percent)
    }

    var retview: some View {
        VStack(spacing: 10) {
            HStack(alignment: .lastTextBaseline) {
                Text(ret)
                    .font(.system(size: 30).bold())

                Text("%")
                    .font(.system(size: 20).bold())
            }
        }
        .frame(width: UIScreen.width - 50, height: 60)
    }

    @State var showselector = false

    var selectionview: some View {
        VStack(spacing: 15) {
            genderselectview

            weightandwaistview

            neckandhipview
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

    var weightandwaistview: some View {
        HStack(spacing: MIDDLE_SPACING) {
            Answernumberfield(title: preference.language("height"),
                              answer: $height,
                              answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                              descriptor: metricorenglish.lengthunit.rawValue,
                              alwaysshowdescriptor: true
            )

            Answernumberfield(title: preference.language("waistcircumference"),
                              answer: $waist,
                              answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                              descriptor: metricorenglish.lengthunit.rawValue,
                              alwaysshowdescriptor: true
            )
        }
    }

    var neckandhipview: some View {
        HStack(spacing: MIDDLE_SPACING) {
            Answernumberfield(title: preference.language("neckcircumference"),
                              answer: $neck,
                              answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                              descriptor: metricorenglish.lengthunit.rawValue,
                              alwaysshowdescriptor: true
            )

            if gender != .male {
                Answernumberfield(title: preference.language("hipcircumference"),
                                  answer: $hip,
                                  answerfontsize: DEFINE_FONT_SMALL_SIZE - 2,
                                  descriptor: metricorenglish.lengthunit.rawValue,
                                  alwaysshowdescriptor: true
                )
            }

            SPACE
        }
    }

    var contenview: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                SPACE.frame(height: MIN_UP_TAB_HEIGHT)

                Question("fatcalculator")

                LocaleText("fatcalculatorcription", usefirstuppercase: false, linelimit: 10)
                    .foregroundColor(NORMAL_GRAY_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
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
