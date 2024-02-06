//
//  Datalastdays.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/8.
//

import SwiftUI

struct Datalastdays_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Datalastdays(days: 7)
        }
    }
}

// workouts in the last 20 days
struct Datalastdays: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var days: Int
    var bigfontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE
    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE

    var descfontcolor: Color = NORMAL_LIGHT_TEXT_COLOR

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 3) {
            let _labeltext = preference.languagewithplaceholder("lastdaysdesc",
                                                                firstletteruppercase: false,
                                                                value: "\(days)")
            Text(_labeltext)
        }
        .foregroundColor(descfontcolor)
        .font(
            .system(size: fontsize, design: .rounded)
            //.bold()
        )
    }
}
