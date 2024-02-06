//
//  Formats.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import Foundation

import SwiftUI

/*
 * tab related
 */
let MAX_UP_TAB_HEIGHT: CGFloat = MIN_UP_TAB_HEIGHT + 120
let MIN_UP_TAB_HEIGHT: CGFloat = 50
let UP_TAB_TITLE_PADDING: CGFloat = 5
let UP_TAB_LETTER_TRACKING: CGFloat = 1

let MIN_DOWN_TAB_HEIGHT: CGFloat = 50
let MIN_DOWN_BUTTON_HEIGHT: CGFloat =  43 //40

/*
 * sheet
 */
let SHEET_HEADER_HEIGHT: CGFloat = MIN_UP_TAB_HEIGHT

let IMAGE_CNT: Int64 = 9

func ofbgplanimage(_ id: Int64) -> Image {
    let idx = ofindex(id, max: IMAGE_CNT)
    return Image("bg_\(idx)")
}

let IMAGE_MUSCLE_CNT: Int64 = 1

func ofbgtemplateimage(_ id: Int64) -> Image {
    let idx = ofindex(id, max: 16)
    return Image("bg_temp_\(idx)")
}

func ofbgimage(_ id: Int64) -> Image {
    let idx = ofindex(id, max: 4)
    return Image("bg_normal_\(idx)")
}

/*
 extension PSIphoneStyle {
     public static func themeStyle() -> PSIphoneStyle {
         return .init(background: .solid(NORMAL_BG_CARD_COLOR),
                      handleBarStyle: .solid(Color.secondary),
                      cover: .enabled(Color.black.opacity(0.4)),
                      cornerRadius: 10
         )
     }
 }
 */

let DARK_MODE: String = "DARK_MODE"
let LIGHT_MODE: String = "LIGHT_MODE"

func setDarkMode(enable: Bool) {
    let defaults = UserDefaults.standard
    defaults.set(enable, forKey: DARK_MODE)
}

func getDarkMode() -> Bool {
    let defaults = UserDefaults.standard
    return defaults.bool(forKey: DARK_MODE)
}

func bartitle(_ title: String, fontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE + 1, color: Color = NORMAL_LIGHTER_COLOR) -> some View {
    HStack {
        LocaleText(title, usefirstuppercase: false)
            .font(.system(size: fontsize).bold())
            .frame(alignment: .leading)
            .lineLimit(1)
            .minimumScaleFactor(0.01)
            .foregroundColor(color)
            .padding(.vertical, 8)
        
        SPACE
    }
}
