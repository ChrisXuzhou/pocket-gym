//
//  Uparrow.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import SwiftUI


struct Uparrow_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Uparrow()
        }
    }
}

struct Uparrow: View {
    
    var up: Bool = true
    var fontsize: CGFloat = 19

    var body: some View {
        Image(systemName:
                up ? "chevron.up.circle.fill" : "chevron.down.circle.fill"
        )
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: fontsize, height: fontsize, alignment: .center)
            .frame(width: 22, height: 22, alignment: .center)
    }
}

