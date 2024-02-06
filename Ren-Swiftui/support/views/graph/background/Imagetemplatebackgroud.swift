//
//  Imagebackgroudbeta.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//

import SwiftUI

struct Imagetemplatebackgroud: View {
    
    @EnvironmentObject var preference: PreferenceDefinition
    
    init(_ firstid: Int64? = nil, secondid: Int64?) {
        self.firstid = firstid
        self.secondid = secondid
    }

    var firstid: Int64?
    var secondid: Int64?

    var body: some View {
        GeometryReader {
            reader in

            ZStack {
                Color.gray.ignoresSafeArea()
                
                if let _secondid = secondid {
                    
                    ofbgtemplateimage(_secondid)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: reader.size.height)
                        .opacity(0.8)
                        .clipped()
                }
                
                preference.theme.opacity(0.2)
                
            }
            .frame(height: reader.size.height)
            .clipped()
            .contentShape(Rectangle())
        }
    }
}

struct Imagebackgroudbeta_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Imagetemplatebackgroud(secondid: 2).frame(height: PLAN_PROGRESS_HEIGHT)
            Imagetemplatebackgroud(0, secondid: 2).frame(height: PLAN_PROGRESS_HEIGHT)
            Imagetemplatebackgroud(1, secondid: 2).frame(height: PLAN_PROGRESS_HEIGHT)
            Imagetemplatebackgroud(2, secondid: 2).frame(height: PLAN_PROGRESS_HEIGHT)
            Imagetemplatebackgroud(3, secondid: 2).frame(height: PLAN_PROGRESS_HEIGHT)
        }
    }
}
