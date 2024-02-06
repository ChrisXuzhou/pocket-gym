//
//  LogoImage.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/4.
//

import SwiftUI

struct LogoImage: View {
    var imgsize: CGFloat = 23
    
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .frame(width: 25, height: 25, alignment: .center)
            .background(
                Circle().foregroundColor(NORMAL_LIGHTEST_GRAY_COLOR)
            )
    }
}

struct LogoImage_Previews: PreviewProvider {
    static var previews: some View {
        LogoImage()
    }
}
