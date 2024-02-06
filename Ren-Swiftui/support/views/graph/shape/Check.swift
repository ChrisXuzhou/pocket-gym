//
//  Check.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/14.
//

import SwiftUI

struct Check_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Check()
                Check(finished: true)
            }
        }
    }
}


let SHAPE_CHECK_FONT_SIZE: CGFloat = 19

struct Check: View {
    var finished: Bool = false
    var fontsize: CGFloat = SHAPE_CHECK_FONT_SIZE
    var color: Color = NORMAL_LIGHT_GRAY_COLOR

    var body: some View {
        Image("checkmark")
            .renderingMode(.template)
            .resizable()
            .frame(width: fontsize, height: fontsize - 4, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .foregroundColor(
                finished ? NORMAL_GREEN_COLOR : color
            )
            .frame(width: 20, height: 20, alignment: .center)
    }
}
