//
//  ExerciseLabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/22.
//

import AudioToolbox
import AVKit
import SwiftUI

protocol ExerciselabelAware {
    /*
     * select related.
     */
    func selectorunselect(_ exercise: Exercisedef)

    /*
     * mark related
     */
    func markorunmark(_ exercise: Exercisedef)

    func canselect() -> Bool

    func labelusage() -> Viewusage
}

let LABEL_VIDEO_WIDTH: CGFloat = 80
let LABEL_VIDEO_HEIGHT: CGFloat = 48
let LABEL_HEIGHT: CGFloat = LABEL_VIDEO_HEIGHT + 10

struct Lablechecker: View {
    var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.circle.fill" : "circle")
            .font(.system(size: DEFINE_BUTTON_FONT_SMALL_SIZE))
    }
}

let EXERCISE_BACKGROUD_RADIUS: CGFloat = 3


struct NavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: DEFINE_BUTTON_FONT_SMALL_SIZE - 5))
            .foregroundColor(NORMAL_GRAY_COLOR)
    }
}

struct TappedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? NORMAL_GRAY_COLOR : NORMAL_BG_CARD_COLOR)
    }
}

enum Videostats {
    case video, img
}
