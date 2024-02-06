//
//  Backtodayshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/1.
//

import SwiftUI

struct Backtodayshape_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Backtodayshape()
        }
    }
}

struct Backtodayshape: View {
    var imgsize: CGFloat = 18

    var body: some View {
        Image("today")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .foregroundColor(NORMAL_BUTTON_COLOR)
    }
}
