//
//  Delete.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import SwiftUI

struct Delete: View {
    
    var fontsize: CGFloat = 19
    
    var body: some View {
        Image("delete")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: fontsize, height: fontsize, alignment: .center)
            .foregroundColor(NORMAL_RED_COLOR)
    }
}

struct Delete_Previews: PreviewProvider {
    static var previews: some View {
        Delete()
    }
}
