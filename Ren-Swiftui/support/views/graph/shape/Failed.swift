//
//  Failed.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/7.
//

import SwiftUI

struct Failed_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Failed()
        }
    }
}

struct Failed: View {
    var fontsize: CGFloat = SHAPE_CHECK_FONT_SIZE

    var body: some View {
        Image("Failed")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: fontsize, height: fontsize, alignment: .center)
            .foregroundColor(NORMAL_RED_COLOR)
            .frame(width: 20, height: 20, alignment: .center)
    }
}
