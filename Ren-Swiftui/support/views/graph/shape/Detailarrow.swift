//
//  Detailarrow.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/6.
//

import SwiftUI

struct Detailarrow: View {
    var arrowfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE

    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: arrowfontsize))
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .padding(10)
    }
}

struct Detailarrow_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Detailarrow()
        }
    }
}
