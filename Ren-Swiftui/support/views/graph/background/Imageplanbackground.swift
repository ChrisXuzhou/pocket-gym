//
//  Imageplanbackground.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Imageplanbackground_Previews: PreviewProvider {
    static var previews: some View {
        Imageplanbackground(1, secondid: 2)
            .frame(height: PLAN_PROGRESS_HEIGHT)
    }
}

struct Imageplanbackground: View {
    init(_ firstid: Int64? = nil, secondid: Int64) {
        self.firstid = firstid
        self.secondid = secondid
    }

    var firstid: Int64?
    var secondid: Int64

    var body: some View {
        GeometryReader {
            reader in

            ZStack {

                if let _firstid = firstid {
                    ofcolor(_firstid)
                }

                ofbgplanimage(secondid)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: reader.size.height)
                    .clipped()
                
                Color.gray.opacity(0.3).ignoresSafeArea()
            }
            .frame(height: reader.size.height)
            .clipped()
            .contentShape(Rectangle())
        }
    }
}
