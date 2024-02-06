//
//  Exportshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/11.
//

import SwiftUI

struct Exportshape_Previews: PreviewProvider {
    static var previews: some View {
        Exportshape()
    }
}

struct Exportshape: View {
    
    var imgsize: CGFloat = 18
    
    var body: some View {
        Image(systemName: "square.and.arrow.up.fill")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .frame(width: 25, height: 25, alignment: .center)
    }
}
