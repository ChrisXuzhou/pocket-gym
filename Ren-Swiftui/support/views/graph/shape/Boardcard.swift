//
//  Boardcard.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Boardcard: View {
    
    var imgsize: CGFloat = 23
    
    var body: some View {
        Image("schedule")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .frame(width: 25, height: 25, alignment: .center)
            .background(
                Circle().foregroundColor(NORMAL_LIGHTEST_GRAY_COLOR)
            )
    }
}

struct Boardcard_Previews: PreviewProvider {
    static var previews: some View {
        Boardcard()
    }
}
