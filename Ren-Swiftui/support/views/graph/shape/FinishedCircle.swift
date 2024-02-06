//
//  FinishedCircle.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/13.
//

import SwiftUI

struct FinishedCircle_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                FinishedCircle(i: 1, finished: false)
                FinishedCircle(i: 2, finished: true)
            }
        }
    }
}

let FINISHED_CIRCLE_SIZE: CGFloat = 20
let FINISHED_CIRCLE_FONT_SIZE: CGFloat = 26
let NUMBER_CIRCLE_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE

struct FinishedCircle: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var i: Int
    var finished: Bool

    var fontsize: CGFloat = NUMBER_CIRCLE_FONT_SIZE - 2
    var circlefontsize: CGFloat = DEFINE_FONT_SMALL_SIZE
    var circlesize: CGFloat = FINISHED_CIRCLE_SIZE

    var finishedview: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: circlefontsize).bold())
            .foregroundColor(NORMAL_GREEN_COLOR)
    }

    var numberview: some View {
        Text("\(i)")
            .lineLimit(1)
            .minimumScaleFactor(0.01)
            .font(.system(size: fontsize).bold())
            .foregroundColor(Color.white)
            .frame(width: circlesize, height: circlesize)
            .background(
                Circle()
                    .foregroundColor(
                        preference.theme
                        // preference.themeprimarycolor
                    )
            )
    }

    var body: some View {
        VStack {
            numberview
        }
    }
}
