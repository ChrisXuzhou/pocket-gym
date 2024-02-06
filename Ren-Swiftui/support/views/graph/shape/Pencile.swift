//
//  Pencile.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

struct Pencile: View {
    
    var imgsize: CGFloat = 26
    
    var body: some View {
        Image("writing")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}

struct Pencile_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Pencile()
        }
    }
}
