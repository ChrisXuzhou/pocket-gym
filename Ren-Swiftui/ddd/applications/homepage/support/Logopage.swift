//
//  Logopage.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/2.
//

import SwiftUI

struct Logopage_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Logopage()
        }
    }
}

struct Logopage: View {
    @EnvironmentObject var preference: PreferenceDefinition


    var contentview: some View {
        VStack {
            SPACE.frame(height: UIScreen.height / 8)

            Logosmall(showlogo: false)
                .padding()

            Exercisevideo()

            LocaleText("appdescription",
                       usefirstuppercase: false,
                       linelimit: 10,
                       alignment: .leading,
                       linespacing: 5)
                .lineSpacing(3)
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1))
                .padding()
                .padding(.horizontal)

            SPACE
        }
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            contentview
        }
    }
}

/*
 
 var imglabel: some View {
     Image("bg_8")
         .resizable()
         .aspectRatio(contentMode: .fit)
         .frame(height: 200, alignment: .center)
 }
 */
