//
//  Pentagram.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/2.
//

import SwiftUI

struct Pentagram_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Pentagram()
        }
    }
}

struct Pentagram: View {
    var size: CGFloat = 22

    var body: some View {
        Image("pentagram.fill")
            .renderingMode(.template)
            .resizable()
            .frame(width: size, height: size, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .frame(width: 26, height: 26, alignment: .center)
    }
}
