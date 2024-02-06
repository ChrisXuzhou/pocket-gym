//
//  Indicator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/27.
//

import SwiftUI

let INDICATOR_HEIGHT: CGFloat = 75
let INDICATOR_DIVIDER: some View = RoundedRectangle(cornerRadius: 2)
    .frame(width: 2)
    .foregroundColor(NORMAL_BG_COLOR)

enum Deltadirection {
    case positive, negative, equal

    var color: Color {
        switch self {
        case .equal:
            return Color.gray // NORMAL_LIGHTER_COLOR
        case .negative:
            return NORMAL_RED_COLOR
        case .positive:
            return NORMAL_HEAT_COLOR
        }
    }
}

let INDICATOR_SECONDARY_COLOR: Color = .gray
let INDICATOR_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE

struct Indicator: View {
    var value: String
    var valuefontsize: CGFloat = INDICATOR_FONT_SIZE - 5

    var valuefooter: String?
    var valuefooterfontsize: CGFloat = INDICATOR_FONT_SIZE - 5

    var description: String?
    var descriptionfontsize: CGFloat = INDICATOR_FONT_SIZE

    var delta: String?
    var deltafooter: String?
    var deltafontsize: CGFloat = DEFINE_FONT_BIGGEST_SIZE
    var deltadirection: Deltadirection = .equal

    var valueview: some View {
        HStack(alignment: .lastTextBaseline, spacing: 5) {
            Text(value)
                .font(.system(size: valuefontsize).bold())
                .lineLimit(1)
                .minimumScaleFactor(0.01)

            if let _f = valuefooter {
                Text(_f)
                    .font(.system(size: valuefooterfontsize).bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
            }
        }
        .foregroundColor(INDICATOR_SECONDARY_COLOR)
    }

    var descriptionview: some View {
        HStack {
            if let _d = description {
                Text(_d.uppercased())
                    .font(.system(size: descriptionfontsize).bold())
                    .lineLimit(2)
                    .minimumScaleFactor(0.01)
            }
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
    }

    var deltaview: some View {
        HStack(spacing: 2) {
            if let _d = delta {
                Image("upArrow")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(deltadirection.color)
                    .rotationEffect(.degrees(deltadirection == .negative ? 180 : 0))

                HStack(alignment: .lastTextBaseline, spacing: 5) {
                    Text(_d)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)

                    if let _df = deltafooter {
                        Text(_df)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                    }
                }
                .font(.system(size: deltafontsize).bold())
            }
        }
        .foregroundColor(NORMAL_COLOR)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 0) {
                descriptionview

                valueview
            }

            deltaview
        }
        .frame(height: INDICATOR_HEIGHT)
    }
}

struct Indicator_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView { VStack(spacing: 50) {
            Indicator(
                value: "30250.5", valuefooter: "KG",
                description: "1RM",
                delta: "200", deltadirection: .equal)

            Indicator(value: "30250.5", description: "Volume")
        }
        .padding()
        }
    }
}
