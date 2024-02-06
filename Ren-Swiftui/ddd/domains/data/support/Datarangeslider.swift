//
//  Datarangeslider.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/7.
//

import SwiftUI

struct Datarangeslider_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Reviewdaysselector(days: .constant(20))

                // Datarangeslider(days: .constant(20))
            }
        }
    }
}

let DATE_MAX_DAYS_AGO: Double = 50.0

struct Datarangeslider: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var days: Int

    var intProxy: Binding<Double> {
        Binding<Double>(get: {
            Double(days)
        }, set: {
            days = Int($0)
            log("\(days)")
        })
    }

    var sliderview: some View {
        Slider(
            value: intProxy,
            in: 0.0 ... DATE_MAX_DAYS_AGO,
            step: 1.0,
            onEditingChanged: { _ in
                log(days.description)
            }
        )
        .accentColor(preference.theme)
    }

    var measureview: some View {
        HStack(spacing: 2) {
            Text("\(0)")

            SPACE

            Text("\(Int(DATE_MAX_DAYS_AGO))")
        }
        .foregroundColor(NORMAL_COLOR)
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
    }

    var daysagoview: some View {
        HStack {
            Datalastdays(days: days)

            SPACE
        }
    }

    var body: some View {
        VStack {
            daysagoview
                .frame(width: UIScreen.width - 60)

            VStack(spacing: 0) {
                measureview
                sliderview
            }
            .frame(width: UIScreen.width - 60)
        }
    }
}
 
struct Reviewdaysselector: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var days: Int
    @State var showselector = false

    var daysagolabel: some View {
        HStack {
            SPACE
            
            Datalastdays(days: days)

            SPACE
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            daysagolabel.padding(.horizontal, 5)

            Answerinput(
                answer: "\(days)",
                focused: showselector
            )
            .frame(width: 250)
            .contentShape(Rectangle())
            .onTapGesture {
                showselector = true
            }
            .sheet(isPresented: $showselector) {
                Intseletctorsheet(
                    selected: $days,
                    rangelist: REVIEW_DAYS_RANGE_LIST,
                    rangedescriptor: preference.language("days")
                )
            }
        }
        .background(
            NORMAL_BG_COLOR.opacity(0.9)
        )
    }
}

let REVIEW_DAYS_RANGE_LIST = [Int](1 ... 90)
