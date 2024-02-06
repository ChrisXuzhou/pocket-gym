//
//  Onermcalculator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/21.
//

import SwiftUI

struct Onermcalculator_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Onermcalculator(present: .constant(true))
        }
    }
}

let MIDDLE_SPACING: CGFloat = 10

struct Onermcalculator: View {
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

    @State var reps: String = ""
    var repsint: Int {
        Int(reps) ?? 0
    }

    @State var weight: String = ""
    var weightkg: Double {
        Double(weight) ?? 0.0
    }

    var ret: String {
        var ret: Double = 0.0
        if !reps.isEmpty && !weight.isEmpty {
            ret = RmCalculator(reps: repsint, weightkg: weightkg).onermkg
        }
        return String(format: "%.1f", ret)
    }

    var retview: some View {
        VStack(spacing: 10) {
            HStack(alignment: .lastTextBaseline) {
                Text(ret)
                    .font(.system(size: 30).bold())

                Text(metricorenglish.weightunit.rawValue)
                    .font(.system(size: 20).bold())
            }
        }
        .frame(width: UIScreen.width - 50, height: 60)
    }

    @State var showselector = false

    var selectionview: some View {
        HStack {
            let reps = preference.language("reps")
            Answernumberfield(numbertype: .integer, title: reps, answer: $reps, descriptor: reps)
            Answernumberfield(title: preference.language("weightlifted"), answer: $weight, descriptor: metricorenglish.weightunit.rawValue, alwaysshowdescriptor: true)
        }
        .padding(.horizontal)
    }

    @State var metricorenglish: Englishormetric = .metric
    var englishormetricview: some View {
        Englishormetricpicker(picked: $metricorenglish)
    }

    var contentview: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                SPACE.frame(height: MIN_UP_TAB_HEIGHT)

                Question("1rmcalculator")

                LocaleText("1rmcalculatorcription", usefirstuppercase: false, linelimit: 10)
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

            contentview

            uptab
        }
        .onTapGesture {
            endtextediting()
        }
        .ignoresSafeArea(.keyboard)
    }
}
