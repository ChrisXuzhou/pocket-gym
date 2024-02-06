//
//  Chartshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import SwiftUI

struct Chartshape_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Chartshape()
        }
    }
}

struct Chartshape: View {
    var imgsize: CGFloat = 26

    var body: some View {
        Image("chartLine")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}
