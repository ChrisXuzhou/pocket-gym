//
//  Nextarrow.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

struct Nextarrow: View {
    var size: CGFloat = 35

    var body: some View {
        Image("next")
            .renderingMode(.template)
            .resizable()
            .frame(width: size, height: size, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50, alignment: .center)
    }
}

struct Nextarrow_Previews: PreviewProvider {
    static var previews: some View {
        Nextarrow()
    }
}
