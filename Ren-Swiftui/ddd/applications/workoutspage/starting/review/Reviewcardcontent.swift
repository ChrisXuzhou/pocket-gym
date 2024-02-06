//
//  Reviewcardcontent.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/11.
//

import SwiftUI

struct Reviewcardcontent: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var model: Reviewcardcontentmodel

    var isint: Bool

    init(left: Double,
         right: Double,
         weightunit: Weightunit? = nil,
         title: String,
         description: String,
         lefttime: Date? = nil,
         righttime: Date? = nil,
         vname: String? = nil,
         isint: Bool = false
    ) {
        let _wrapped = Reviewcardcontentmodel(
            left: left,
            right: right,
            title: title,
            description: description,
            weightunit: weightunit,
            lefttime: lefttime,
            righttime: righttime,
            vname: vname
        )

        model = _wrapped
        self.isint = isint
    }

    var fontcolor: Color = NORMAL_LIGHTER_COLOR
    var subfontcolor: Color = NORMAL_GRAY_COLOR.opacity(0.7)

    var body: some View {
        content
            .frame(height: 250)
    }

    var content: some View {
        VStack(spacing: 0) {
            SPACE.frame(height: 20)

            titlelabel

            timeandvalues

            ZStack {
                valuedetail

                valuesuammary
            }
            .padding(.bottom, 30)
        }
    }
}

extension Reviewcardcontent {
    var titlelabel: some View {
        HStack {
            SPACE
            if let _title = model.title {
                LocaleText(_title)
                    .font(
                        .system(size: DEFINE_FONT_SMALL_SIZE, design: .rounded)
                            .bold()
                    )
                    .foregroundColor(fontcolor)
                    .padding(.bottom, 20)
                    .contentShape(Rectangle())
            }
            SPACE
        }
    }

    var deltalabel: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let _description = model.description {
                LocaleText(_description, usefirstuppercase: false)
                    .font(
                        .system(size: DEFINE_FONT_SMALLER_SIZE)
                            .weight(.heavy)
                    )
            }

            HStack(spacing: 5) {
                let delta = model.delta

                Image("upArrow")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 28, height: 30)
                    .foregroundColor(delta.directcolor)
                    .rotationEffect(.degrees(delta.direct == .negative ? 180 : 0))

                HStack(alignment: .lastTextBaseline, spacing: 5) {
                    Text(isint ? "\(Int(delta))" : delta.displayin1digit)
                        .font(.system(size: DEFINE_FONT_BIG_SIZE).weight(.heavy))

                    if let _weightunit = model.weightunit {
                        LocaleText(_weightunit.name)
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE).weight(.heavy))
                    }
                }
                .foregroundColor(NORMAL_LIGHTER_COLOR)

                SPACE
            }
        }
        .foregroundColor(fontcolor)
    }

    func timeandvalue(_ time: Date?, value: Double, color: Color = NORMAL_LIGHTER_COLOR) -> some View {
        VStack(spacing: 2) {
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                Text(
                    isint ?
                        "\(Int(value))" :
                        value.displayin1digit
                )
                .font(
                    .system(size: DEFINE_FONT_SMALL_SIZE)
                        .weight(.heavy)
                )

                if let _weightunit = model.weightunit {
                    LocaleText(_weightunit.name)
                        .font(
                            .system(size: DEFINE_FONT_SMALLER_SIZE - 2)
                                .weight(.heavy)
                        )
                }
            }
            .font(
                .system(size: DEFINE_FONT_SMALLER_SIZE)
                    .weight(.heavy)
            )

            if let _time: Date = time {
                Text(_time.displayedyearmonthdate)
                    .font(
                        .system(size: DEFINE_FONT_SMALLER_SIZE - 2)
                            .weight(.heavy)
                    )
            }
        }
        .foregroundColor(color)
    }

    var timeandvalues: some View {
        HStack(alignment: .center, spacing: 5) {
            SPACE

            let rightcolor = model.delta.directcolor

            if model.left > 0 {
                timeandvalue(model.lefttime,
                             value: model.left,
                             color: subfontcolor
                )

                Image(systemName: "arrow.right")
                    .font(
                        .system(size: DEFINE_FONT_SMALLER_SIZE)
                            .bold()
                    )
                    .foregroundColor(rightcolor)
                    .padding(.horizontal)
            }

            timeandvalue(model.righttime,
                         value: model.right,
                         color: subfontcolor
            )

            SPACE
        }
    }

    var chartcontent: some View {
        HStack {
            let height: CGFloat = 75
            let ratio = model.lefty == model.righty ? 0.8 : 1

            ZStack {
                let y: Double = model.lefty
                if y > 0.0 {
                    Rectangle()
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                        .frame(width: 30, height: y * height * ratio)
                        .foregroundColor(NORMAL_GRAY_COLOR)
                        .offset(y: (abs(1 - y) * height) / 2)
                        .contentShape(Rectangle())
                }
            }

            ZStack {
                let y: Double = model.righty
                if y > 0.0 {
                    Rectangle()
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                        .frame(width: 30, height: y * height * ratio)
                        .foregroundColor(preference.themeprimarycolor)
                        .offset(y: (abs(1 - y) * height) / 2)
                        .contentShape(Rectangle())
                }
            }

            SPACE
        }
    }

    var valuedetail: some View {
        VStack(alignment: .trailing) {
            SPACE

            chartcontent
        }
        .padding(.leading, 30)
    }

    var valuesuammary: some View {
        VStack {
            SPACE

            deltalabel
                .padding(.leading, 130)
        }
    }
}

private extension Double {
    var direct: Deltadirection {
        if self < 0 {
            return .negative
        }
        if self == 0 {
            return .equal
        }
        return .positive
    }

    var directcolor: Color {
        if self <= 0 {
            return NORMAL_GRAY_COLOR
        }

        return PreferenceDefinition.shared.theme
    }
}
