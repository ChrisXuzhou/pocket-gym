//
//  Downarrow.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import SwiftUI

struct Downarrow: View {
    var body: some View {
        Image("downarrow")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 19, height: 19, alignment: .center)
    }
}

struct Downarrow_Previews: PreviewProvider {
    static var previews: some View {
        Downarrow()
    }
}
