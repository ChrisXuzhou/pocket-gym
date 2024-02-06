//
//  Coffee.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/20.
//

import SwiftUI

struct Coffee_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Coffee(imgsize: 25)
        }
    }
}

struct Coffee: View {
    var imgsize: CGFloat = 30

    var body: some View {
        Image("coffee")
            .renderingMode(.template)
            .resizable()
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .aspectRatio(contentMode: .fill)
    }
}
