//
//  TimerTextView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/15.
//

import SwiftUI

struct Restimertext_Previews: PreviewProvider {
    static var previews: some View {
        
        DisplayedView {
            VStack {
                var restimer = Restimer(interval: 10)  {_ in}

                Restimertext(restimer: restimer)
                    .background(.white)


                var restimer2 = Restimer(interval: 1000)  {_ in}

                Restimertext(restimer: restimer2)
                    .background(.white)

            }
        }
    }
}

public struct Restimertext: View {
    @EnvironmentObject var preference: PreferenceDefinition
    
    @ObservedObject var restimer: Restimer

    var fontcolor: Color = NORMAL_COLOR
    var textsize: CGFloat = DEFINE_FONT_SMALL_SIZE
    var limittextsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 4
    var bellsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 5

    var limitview: some View {
        HStack(spacing: 3) {

            /*
             
            Text(restimer.formattedlimitduration)
                .font(.system(size: limittextsize).bold())
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .foregroundColor(preference.theme)
             
             
             */
        }
    }

    var countingview: some View {
        HStack {
            
            /*
             
             
             if restimer.status == .stop {
                 LocaleText("timeup")
                     .font(.system(size: DEFINE_FONT_SIZE, design: .rounded).bold())
                 
             } else {
                 Text(restimer.formattedduration)
                     .foregroundColor(fontcolor)
             }
             
             
             */
            
        }
        .font(.system(size: textsize, design: .rounded).bold())
        .lineLimit(1)
        .minimumScaleFactor(.leastNonzeroMagnitude)
        .foregroundColor(fontcolor)
    }

    public var body: some View {
        return VStack(alignment: .center) {
            countingview
                .padding(.top, 5)

            limitview
        }
    }
}
