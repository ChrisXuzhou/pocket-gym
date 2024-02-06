//
//  Preferencegraph.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import SwiftUI

struct Preferencegraph: View {
    var body: some View {
        Image("personal")
            .renderingMode(.template)
            .resizable()
            .frame(width: 18, height: 18, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .frame(width: 23, height: 23, alignment: .center)
        
    }
}

struct Preferencegraph_Previews: PreviewProvider {
    static var previews: some View {
        Preferencegraph()
    }
}
