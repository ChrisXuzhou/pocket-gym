//
//  Imagelabelbackground.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//

import SwiftUI

struct Imageplanlabelbackground: View {
    init(_ firstid: Int64,
         _ secondid: Int64) {
        self.firstid = firstid
        self.secondid = secondid
    }

    var firstid: Int64
    var secondid: Int64

    var body: some View {
        GeometryReader {
            reader in

            ZStack {
                Color.gray
                
                ofcolor(firstid)

                ofbgplanimage(secondid)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: reader.size.height)
                    .clipShape(
                        Parallelogram(depth: 50)
                    )
                    .offset(x: UIScreen.width / 3)
                    .clipped()
            }
            .frame(height: reader.size.height)
            .clipped()
            .contentShape(Rectangle())
            .opacity(0.2)
        }
    }
}

struct Imagebackground_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Imageplanlabelbackground(0, 2).frame(height: PLAN_PROGRESS_HEIGHT)
            Imageplanlabelbackground(1, 2).frame(height: PLAN_PROGRESS_HEIGHT)
            Imageplanlabelbackground(2, 2).frame(height: PLAN_PROGRESS_HEIGHT)
            Imageplanlabelbackground(3, 2).frame(height: PLAN_PROGRESS_HEIGHT)
        }
    }
}
