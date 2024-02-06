//
//  Copy.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import SwiftUI

struct Copy: View {
    var body: some View {
        Image("copy")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 18, height: 18, alignment: .center)
    }
}

struct Copy_Previews: PreviewProvider {
    static var previews: some View {
        Copy()
    }
}
