//
//  Plus.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

struct Plus: View {
    
    var fontsize: CGFloat = DEFINE_BUTTON_FONT_BIG_SIZE + 1
    
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .font(
                .system(size: fontsize).bold()
            )
    }
}

struct Plus_Previews: PreviewProvider {
    static var previews: some View {
        Plus()
    }
}
