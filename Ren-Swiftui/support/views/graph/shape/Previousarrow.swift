//
//  Previousarrow.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/14.
//

import SwiftUI

struct Previousarrow: View {
    var size: CGFloat = 35

    var body: some View {
        Image("previous")
            .renderingMode(.template)
            .resizable()
            .frame(width: size, height: size, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50, alignment: .center)
    }
}

struct Previousarrow_Previews: PreviewProvider {
    static var previews: some View {
        Previousarrow()
    }
}
