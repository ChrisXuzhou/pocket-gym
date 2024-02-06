//
//  Musclefrequencyview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/24.
//

import SwiftUI

struct Musclefrequencyview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Musclefrequencyview()
        }
    }
}

struct Musclefrequencyview: View {
    @StateObject var assessmodel = Musclefrequencymodel()
    @State var focusedid: String = "chest"

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                SPACE.frame(height: 30)
                
                radarchart
                
                SPACE.frame(height: 50)
                
                menupanel.padding(.horizontal, 10)

                assessdetail
            }
            .environmentObject(assessmodel)
            .padding(.horizontal, 10)
            
        }
    }
}

extension Musclefrequencyview {
 
    var header: some View {
        HStack {
            LocaleText("scoreheadertitle", usefirstuppercase: false, alignment: .center)
                .font(.system(size:DEFINE_FONT_SIZE).weight(.heavy))
                .foregroundColor(NORMAL_GRAY_COLOR)
        }
        .padding(.vertical, 20)
    }
    
}

extension Musclefrequencyview {
    var assessdetail: some View {
        ZStack {
            VStack {
                if let _assess = assessmodel.dictionary[focusedid] {
                    Muscleradarmodeldetail(muscleassess: _assess)
                } else {
                    SPACE
                }
                
                COPYRIGHT
            }
        }
        .frame(minHeight: UIScreen.height * 2 / 3)
    }

    var radarchart: some View {
        ZStack {
            
            let width: CGFloat = 230
            let height: CGFloat = 200
            
            MusclescoreradarView()
                .frame(width: width, height: height)
        }
        .frame(height: 200)
        
    }
    
    var menupanel: some View {
        Musclefrequencymenu($focusedid)
    }
}
