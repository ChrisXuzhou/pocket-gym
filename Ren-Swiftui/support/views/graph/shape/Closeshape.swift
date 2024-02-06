//
//  Closeshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/6.
//

import SwiftUI

struct Closeshape_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Closeshape()
        }
    }
}

struct Closeshape: View {
    var imgsize: CGFloat = 40
    var fontsize: CGFloat = DEFINE_FONT_BIGGEST_SIZE

    var body: some View {
        Image(systemName: "multiply.circle.fill")
            .font(.system(size: fontsize).bold())
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}
