//
//  Foldershape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/1.
//

import SwiftUI

struct Foldershape_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Foldershape()
        }
    }
}

struct Foldershape: View {
    var imgsize: CGFloat = 18

    var body: some View {
        Image("folder")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}
