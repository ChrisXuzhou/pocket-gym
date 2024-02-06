//
//  Slideeditor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/5.
//

import SwiftUI

struct Slideeditor_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Slideeditor(value: .constant(50), description: "s" )
        }
    }
}

struct Slideeditor: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var value: Int
    var description: String?
    var min: Int = 0
    var max: Int = 99
    var step: Double = 1.0

    var intProxy: Binding<Double> {
        Binding<Double>(get: {
            Double(value)
        }, set: {
            log($0.description)
            value = Int($0)
        })
    }

    var sliderview: some View {
        Slider(
            value: intProxy,
            in: Double(min) ... Double(max),
            step: step,
            onEditingChanged: { _ in
            }
        )
        .accentColor(preference.theme)
    }

    var measureview: some View {
        HStack(spacing: 2) {
            Text("\(min)")

            SPACE

            Text("\(max)")
        }
        .foregroundColor(NORMAL_COLOR)
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
    }

    var displayview: some View {
        HStack(alignment: .lastTextBaseline, spacing: 5) {
            SPACE

            LocaleText(value.description)
                .font(.system(size: 30).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)
            
            if let _d = description {
                LocaleText(_d)
                    .font(.system(size: DEFINE_FONT_BIG_SIZE).bold())
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                
            }

            SPACE
        }
        .padding()
    }

    var body: some View {
        VStack {
            displayview
                .frame(width: UIScreen.width - 60)

            VStack(spacing: 0) {
                measureview
                sliderview
            }
            .frame(width: UIScreen.width - 60)
        }
        .frame(height: UIScreen.height / 2)
    }
}
