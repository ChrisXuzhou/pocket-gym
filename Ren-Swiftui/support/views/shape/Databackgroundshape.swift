//
//  Databackgroundshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/21.
//

import SwiftUI

struct Databackgroundshape_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Databackgroundshape(color: .red)
                .frame(width: 200, height: 50)
        }
    }
}

struct Databackgroundshape: View {
    var color: Color = NORMAL_BG_COLOR
    var delta: CGFloat = 12

    var body: some View {
        GeometryReader {
            reader in

            let width = reader.size.width
            let height = reader.size.height

            Path { path in
                
                // 0
                path.move(
                    to: CGPoint(
                        x: 0 * width,
                        y: 0 * height
                    )
                )
                
                // 1
                path.addLine(
                    to: CGPoint(
                        x: 0 * width,
                        y: 1 * height
                    )
                )
                // 2
                path.addLine(
                    to: CGPoint(
                        x: 1 * width - delta,
                        y: 1 * height)
                )
                // 3
                path.addLine(
                    to: CGPoint(
                        x: 1 * width,
                        y: 0 * height)
                )
                // 4
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}
