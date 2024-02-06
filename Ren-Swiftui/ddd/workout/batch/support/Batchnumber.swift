//
//  Batchnumber.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/4.
//

import SwiftUI

struct Batchnumber_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView{
            VStack {
                Batchnumber(number: 1)
                Batchnumber(number: 15)
                Batchnumber(number: 100)
            }
        }
    }
}

let BATCHNUMBER_FONT_SIZE: CGFloat = DEFINE_FONT_SIZE
let BATCHNUMBER_WIDTH: CGFloat = 35
let BATCHNUMBER_HEIGHT: CGFloat = 35

struct Batchnumber: View {
    
    @EnvironmentObject var preferenece: PreferenceDefinition
    
    var number: Int
    var fontsize: CGFloat = BATCHNUMBER_FONT_SIZE

    var body: some View {
        HStack {
            LocaleText("\(number)")
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .font(.system(size: fontsize).bold())
        }
        .frame(width: BATCHNUMBER_WIDTH, height: BATCHNUMBER_HEIGHT)
        /*
         .background(
             Circle().foregroundColor(preferenece.themesecondarycolor)
         )
         */
    }
}
