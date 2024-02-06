//
//  Routinelogcontenttitle.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/8.
//

import SwiftUI

let DEFAULT_ROUTINE_LOG_CONTENT_TITLE_HEIGHT: CGFloat = 40

struct Routinelogcontenttitle: View {
    @EnvironmentObject var model: Workoutandeachlogmodel

    var editing: Bool = false
    var weightunit: Weightunit
    var width: CGFloat = DEFAULT_ROUTINE_CONTENT_EACH_WIDTH
    var height: CGFloat = DEFAULT_ROUTINE_LOG_CONTENT_TITLE_HEIGHT

    var repsview: some View {
        LocaleText("reps", uppercase: true)
            .frame(width: width, height: height)
    }

    var weightview: some View {
        LocaleText(weightunit.name, uppercase: true)
            .frame(width: width, height: height)
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            repsview

            weightview

            if model.isfinished {
                if editing {
                    LocaleText("restimesecs", uppercase: true)
                        .frame(width: width, height: height)
                } else {
                    LocaleText("restimeshort", uppercase: true)
                        .frame(width: width, height: height)
                }
            }
        }
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2).bold())
        .foregroundColor(NORMAL_BUTTON_COLOR)
    }
}
