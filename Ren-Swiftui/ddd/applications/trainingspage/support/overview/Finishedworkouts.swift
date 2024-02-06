//
//  Finishedworkouts.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/21.
//

import SwiftUI

struct Finishedworkouts_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Finishedworkouts()
        }
    }
}

struct Finishedworkouts: View {
    @Namespace private var animation
    @EnvironmentObject var preference: PreferenceDefinition

    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 3
    var fontcolor: Color = NORMAL_LIGHTER_COLOR.opacity(0.7)

    var finishedstr: String {
        let _now = Date()

        
        var curret = Calendar.current
        curret.locale = PreferenceDefinition.shared.oflanguage.locale
        
        // 1、month
        // let month = preference.language("\(_now.month)month")
        let month = curret.monthSymbols[_now.month - 1]

        // 2、workouts count
        let interval = Calendar.current.dateInterval(of: .month, for: _now) ?? DateInterval(start: _now, duration: 1)
        let count = AppDatabase.shared.countworkout(interval, stats: .finished)

        var _ret = ""
        if count == 1 {
            let raw = preference.language("completeworkouttime", firstletteruppercase: false)

            _ret = raw
                .replacingOccurrences(of: "{MONTH}", with: "\(month)")
        } else if count > 1 {
            let raw = preference.language("completeworkouttimes", firstletteruppercase: false)

            _ret = raw
                .replacingOccurrences(of: "{COUNT}", with: "\(count)")
                .replacingOccurrences(of: "{MONTH}", with: "\(month)")
        } else {
            let raw = preference.language("notcompleteworkouttimes", firstletteruppercase: false)
            // notcompleteworkouttimes

            _ret = raw
                .replacingOccurrences(of: "{MONTH}", with: "\(month)")
        }

        return _ret
    }

    var body: some View {
        HStack {
            let _str = finishedstr

            Text(_str)
                .font(.system(size: fontsize).bold())
                .foregroundColor(fontcolor)
        }
        .transition(.opacity)
    }
}
