//
//  PlanworkoutIndicator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/19.
//

import SwiftUI

struct Routineindicator_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView(backgroundcolor: NORMAL_THEME_COLOR) {
            VStack(spacing: 30) {
                Routineindicator(description: "exercises", value: "10")

                Routineindicator(type: .horizontal, description: "exercises", value: "10")
            }
            .environmentObject(PreferenceDefinition())
        }
    }
}

enum RoutineindicatorType {
    case horizontal, vertical
}

struct Routineindicator: View {
    var type: RoutineindicatorType = .vertical

    var description: String
    var descriptioncolor: Color = .white

    var value: String

    var fontcolor: Color = .white

    var verticalview: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                LocaleText(description)
                    .foregroundColor(descriptioncolor)
                    .font(
                        .system(size: DEFINE_FONT_SMALLER_SIZE)
                        .bold()
                    )

                SPACE
            }

            Text(value)
                .bold()
                .tracking(0.6)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE))
        }
    }

    var horizontalview: some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            Text(description)
                .font(
                    .system(size: DEFINE_FONT_SMALLER_SIZE - 2)
                        .bold()
                )

            Text(value)
                .tracking(0.6)
                .font(
                    .system(size: DEFINE_FONT_SMALLER_SIZE)
                        .weight(.heavy)
                        .italic()
                )
                .foregroundColor(descriptioncolor)
        }
    }

    var body: some View {
        HStack {
            switch type {
            case .horizontal:
                horizontalview
            case .vertical:
                verticalview
            }
        }
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
        .foregroundColor(fontcolor)
    }
}
