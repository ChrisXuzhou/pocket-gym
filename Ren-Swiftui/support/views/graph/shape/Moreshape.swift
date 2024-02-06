//
//  More.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/2.
//

import SwiftUI

struct More_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Moreshape()
        }
    }
}

struct Moreshape: View {
    var imgsize: CGFloat = 16
    var color: Color = NORMAL_LIGHTER_COLOR

    var body: some View {
        Image(systemName: "ellipsis")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .foregroundColor(color)
            
    }
}



