//
//  Achievementselector.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/3.
//

import SwiftUI

struct Achievementselector_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Achievementselector(selected: .constant(.onerm))
        }
    }
}

enum Exercisedatatype: String, CaseIterable {
    case onerm, max, volume, sets

    var name: String {
        switch self {
        case .onerm:
            return "1rm"
        case .max:
            return "maxweight"
        case .volume:
            return "volume"
        case .sets:
            return "setstitle"
        }
    }

    var color: Color {
        return NORMAL_BLUE_COLOR
    }

    var index: Int {
        switch self {
        case .onerm:
            return 0
        case .max:
            return 1
        case .volume:
            return 2
        case .sets:
            return 3
        }
    }
    
    var ratio: CGFloat {
        switch self {
        case .onerm:
            return 0.9
        case .max:
            return 0.8
        case .volume:
            return 1
        case .sets:
            return 0.7
        }
    }
}

struct Achievementselector: View {
    @Binding var selected: Exercisedatatype

    var body: some View {
        HStack(spacing: 5) {
            AchievementselectorIcon(achievement: .onerm, selected: $selected)
            AchievementselectorIcon(achievement: .max, selected: $selected)
            AchievementselectorIcon(achievement: .volume, selected: $selected)
        }
    }
}

let RESULTSS_SELECTOR_HEIGHT: CGFloat = 30
let RESULTSS_SELECTOR_WIDTH: CGFloat = 80
let RESULTSS_SELECTOR_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE - 3

struct AchievementselectorIcon: View {
    @EnvironmentObject var preference: PreferenceDefinition
    let achievement: Exercisedatatype
    @Binding var selected: Exercisedatatype

    var focused: Bool {
        achievement == selected
    }

    var body: some View {
        HStack(spacing: 20) {
            Text(preference.language(achievement.name).uppercased())
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 3).bold())
                .lineLimit(4)
                .minimumScaleFactor(0.01)
                .foregroundColor(
                    focused ? .white : NORMAL_LIGHTER_COLOR
                )
                .padding(.horizontal, 5)
        }
        .frame(width: RESULTSS_SELECTOR_WIDTH,
               height: RESULTSS_SELECTOR_HEIGHT)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(
                    focused ?
                        preference.themeprimarycolor :
                        NORMAL_LIGHTEST_GRAY_COLOR
                )
        )
        .onTapGesture {
            selected = achievement
        }
    }
}
