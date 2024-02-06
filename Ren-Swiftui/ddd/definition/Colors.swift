//
//  Colors.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/19.
//

import Foundation
import SwiftUI

/*
 *
 * basic color
 *
 */
let NORMAL_HEAT_COLOR: Color = Color("Heat")
let NORMAL_GRAY_COLOR: Color = Color("Gray")
let NORMAL_LIGHT_BLUE_COLOR: Color = Color("LightBlue")
let NORMAL_TOMATO_COLOR: Color = Color("Tomato")
let NORMAL_TANGERINE_COLOR: Color = Color("Tangerine")
let NORMAL_BANANA_COLOR: Color = Color("Banana")
let NORMAL_BASIL_COLOR: Color = Color("Basil")
let NORMAL_SAGE_COLOR: Color = Color("Sage")
let NORMAL_PEACOCK_COLOR: Color = Color("Peacock")
let NORMAL_BLUEBERRY_COLOR: Color = Color("Blueberry")
let NORMAL_LAVENDER_COLOR: Color = Color("Lavender")
let NORMAL_GRAPE_COLOR: Color = Color("Grape")
let NORMAL_FLAMINGO_COLOR: Color = Color("Flamingo")

let NORMAL_THEME_COLOR: Color = Color("Theme")
let NORMAL_THEME_PINK_COLOR: Color = Color("ThemePink")
let NORMAL_BLUE_COLOR: Color = Color.blue //Color("Blue")
let NORMAL_GREEN_COLOR: Color = Color("Green")
let NORMAL_YELLOW_COLOR: Color = Color("Yellow")
let NORMAL_GOLD_COLOR: Color = Color("Gold")
let NORMAL_RED_COLOR: Color = Color.red // Color("Red")

/*
 *
 * background related.
 *
 */
let NORMAL_BG_COLOR: Color = Color("Background")
let NORMAL_BG_CARD_COLOR: Color = Color("BackgroundCard")

let NORMAL_BG_VIDEO_COLOR: Color = Color("Exercisebackgroundcolor")
let NORMAL_BG_BUTTON_COLOR: Color = NORMAL_GRAY_COLOR.opacity(0.3)
let NORMAL_BG_GRAY_COLOR: Color = NORMAL_GRAY_COLOR.opacity(0.1)

/*
 *
 * shaddow
 *
 */
let NORMAL_CARD_SHADDOW_COLOR: Color = Color("CardShaddow")

/*
 *
 * primary or secondary color
 *
 */
let NORMAL_COLOR: Color = Color("Primary")
let NORMAL_LIGHTER_COLOR: Color = Color("Secondary")

/*
 *
 * domain color
 *
 */
let NORMAL_BUTTON_COLOR: Color = Color("Button")
let NORMAL_LIGHT_TEXT_COLOR: Color = Color("LightText")
let NORMAL_LIGHT_BUTTON_COLOR: Color = NORMAL_BUTTON_COLOR.opacity(0.6) // NORMAL_GRAY_COLOR


let NORMAL_UPTAB_BACKGROUND_COLOR: some View = NORMAL_BG_COLOR.opacity(0.95).ignoresSafeArea()

let NORMAL_LIGHT_GRAY_COLOR: Color = NORMAL_GRAY_COLOR.opacity(0.5) // Color(.systemGray3)
let NORMAL_LIGHTEST_GRAY_COLOR: Color = Color(.systemGray5)

let NORMAL_WARMUP_COLOR: Color = NORMAL_HEAT_COLOR
let NORMAL_SUPER_COLOR: Color = NORMAL_HEAT_COLOR.opacity(0.6)

let NORMAL_DELETE_COLOR: Color = .red.opacity(0.8)

let NORMAL_WORKOUT_BACKGROUND_COLOR: Color = NORMAL_BG_CARD_COLOR // NORMAL_LIGHT_GRAY_COLOR

let NORMAL_EXERCISE_OVERLAYED_COLOFR: Color = .black.opacity(0.2)

let NORMAL_COLORS: [Color] =
    [
        NORMAL_TOMATO_COLOR,
        NORMAL_TANGERINE_COLOR,
        NORMAL_BANANA_COLOR,
        NORMAL_BASIL_COLOR,
        NORMAL_SAGE_COLOR,
        NORMAL_PEACOCK_COLOR,
        NORMAL_BLUEBERRY_COLOR,
        NORMAL_LAVENDER_COLOR,
        NORMAL_GRAPE_COLOR,
        NORMAL_FLAMINGO_COLOR,
    ]

let LIGHT_LOCAL_DIVIDER: some View = AnyView(
    Rectangle()
        .frame(height: 0.3)
        .foregroundColor(
            NORMAL_GRAY_COLOR.opacity(0.2)
        )
)

let LOCAL_DIVIDER: some View = AnyView(
    Rectangle()
        .frame(height: 0.4)
        .foregroundColor(
            NORMAL_GRAY_COLOR.opacity(0.35)
        )
)

let VERTICAL_DIVIDER: some View = AnyView(
    Rectangle()
        .frame(width: 0.7)
        .foregroundColor(
            NORMAL_LIGHT_GRAY_COLOR.opacity(0.35)
        )
)
