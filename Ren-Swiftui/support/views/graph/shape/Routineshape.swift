//
//  Routineshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/29.
//

import SwiftUI

struct Routineshape_Previews: PreviewProvider {
    static var previews: some View {
        Routineshape()
    }
}

struct Routineshape: View {
    
    var fontsize: CGFloat = DEFINE_BUTTON_FONT_BIG_SIZE + 1
    
    var body: some View {
        Image(systemName: "routine")
            .renderingMode(.template)
            .resizable()
            .frame(width: fontsize + 5, height: fontsize, alignment: .center)
            .frame(width: 25, height: 25, alignment: .center)
    }
}
