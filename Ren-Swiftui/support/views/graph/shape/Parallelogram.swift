//
//  Parallelogram.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//

import SwiftUI

struct Parallelogram_Previews: PreviewProvider {
    static var previews: some View {
        Parallelogram(depth: 100)
    }
}

struct Parallelogram: Shape {
    
    var depth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: depth, y: 0))
            p.addLine(to: CGPoint(x: rect.width, y: 0))
            p.addLine(to: CGPoint(x: rect.width, y: rect.height))
            p.addLine(to: CGPoint(x: 0, y: rect.height))
            p.closeSubpath()
        }
    }
}
