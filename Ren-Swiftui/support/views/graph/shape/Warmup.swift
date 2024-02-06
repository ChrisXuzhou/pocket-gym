//
//  Warmup.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/11.
//

import SwiftUI

struct Warmup_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Warmup()
                    .foregroundColor(NORMAL_GRAY_COLOR)

                Warmup()
                    .foregroundColor(NORMAL_YELLOW_COLOR)
            }
        }
    }
}

struct Warmup: View {
    var imgsize: CGFloat = 16

    var body: some View {
        Image("calorie")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .frame(width: 25, height: 25, alignment: .center)
            
    }
}
