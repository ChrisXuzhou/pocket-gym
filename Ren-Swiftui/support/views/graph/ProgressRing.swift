//
//  ProgressRing.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/9.
//

import SwiftUI

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ProgressRing()
        }
    }
}

var RING_WIDTH_HEIGHT: CGFloat = 30

struct ProgressRing: View {
    var finished: Bool = false

    var circle: some View {
        ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: 5))
                .frame(width: RING_WIDTH_HEIGHT, height: RING_WIDTH_HEIGHT)

            Circle()
                .trim(from: 0.2, to: 1)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    ),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .frame(width: RING_WIDTH_HEIGHT, height: RING_WIDTH_HEIGHT)
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .shadow(color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)).opacity(0.3), radius: 3, x: 0, y: 3)
        }
    }

    var body: some View {
        HStack {
            circle
        }
    }
}
