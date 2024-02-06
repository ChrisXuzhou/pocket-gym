//
//  Replace.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import SwiftUI

struct Replace: View {
    
    var size: CGFloat = 21
    
    var body: some View {
        Image("replace")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size, alignment: .center)
    }
}

struct Replace_Previews: PreviewProvider {
    static var previews: some View {
        Replace()
    }
}
