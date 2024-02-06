//
//  Stop.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/4.
//

import SwiftUI

struct Stop_Previews: PreviewProvider {
    static var previews: some View {
        Stop()
    }
}

struct Stop: View {
    
    var fontsize: CGFloat = DEFINE_BUTTON_FONT_BIG_SIZE + 1
    
    var body: some View {
        Image(systemName: "stop.circle.fill")
            .font(
                .system(size: fontsize).bold()
            )
    }
}
