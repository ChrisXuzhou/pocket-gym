//
//  Minus.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/23.
//

import SwiftUI

struct Minus_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Minus()
        }
    }
}

struct Minus: View {
    
    var imgsize: CGFloat = 16
    
    var body: some View {
        Image(systemName: "minus.circle.fill")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .foregroundColor(NORMAL_RED_COLOR)
            .frame(width: 22, height: 22, alignment: .center)
    }
}
