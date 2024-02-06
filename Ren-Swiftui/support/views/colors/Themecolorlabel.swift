//
//  ThemecolorView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/13.
//

import SwiftUI

struct ThemecolorView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                
                ForEach(Themecolor.allCases, id: \.self) {
                    themecolor in

                    Themecolorlabel(themecolor: themecolor)
                }
            }
        }
    }
}

enum Themecolor: String, CaseIterable, Codable {
    case blue, pink, red, peacock, lavender

    var colorname: String {
        switch self {
        case .blue:
            return "Theme"
        case .pink:
            return "ThemePink"
        case .red:
            return "Red"
        case .peacock:
            return "Peacock"
        case .lavender:
            return "Lavender"
        }
    }

    var color: Color {
        Color(colorname)
    }
}

struct Themecolorlabel: View {

    var themecolor: Themecolor
    var themesize: CGFloat = 25

    var body: some View {
        Circle()
            .frame(width: themesize, height: themesize, alignment: .center)
            .foregroundColor(themecolor.color)
    }
}
