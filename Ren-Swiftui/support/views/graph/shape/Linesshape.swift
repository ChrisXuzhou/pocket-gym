//
//  Viewindex.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/1.
//

import SwiftUI

struct Linesshape_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Linesshape()
        }
    }
}

//
struct Linesshape: View {
    var imgsize: CGFloat = 35

    var body: some View {
        Image(systemName: "line.3.horizontal")
            .font(.system(size: DEFINE_FONT_BIG_SIZE).bold())
            .scaleEffect(1)
            .opacity(1)
            .foregroundColor(NORMAL_BUTTON_COLOR)
            .frame(width: 35, height: 35)
    }
}
