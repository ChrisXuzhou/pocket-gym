//
//  Rightarrow.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/25.
//

import SwiftUI

struct Rightarrow_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Rightarrow()
        }
    }
}

struct Rightarrow: View {
    var imgsize: CGFloat = 20

    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}
