//
//  Programshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/24.
//

import SwiftUI

struct Programshape: View {
    
    var size: CGFloat = 21
    
    var body: some View {
        Image("compass")
            .renderingMode(.template)
            .resizable()
            .frame(width: size, height: size, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .frame(width: 25, height: 25, alignment: .center)
    }
}

struct Programshape_Previews: PreviewProvider {
    static var previews: some View {
        Programshape()
    }
}
