//
//  ExercisedetailView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/25.
//

import SwiftUI

struct ExercisedetailView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var presentmode

    @ObservedObject var exercise: Newdisplayedexercise

    /*
     * definition
     */
    var textfontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE
    var textfontcolor: Color = NORMAL_LIGHTER_COLOR

    var body: some View {
        
        VStack {
            targetareapanel

            equipmentspanel

            logcontentpanel
            
            Group {
                weightmultiplyerpanel
                
                weightmultiplyerpaneldesc
            }
            
            COPYRIGHT
        }
    }
    
    
/*
ScrollView(.vertical, showsIndicators: false) {
 // videopanel

 
}

*/
}

// header and video
extension ExercisedetailView {
    var equipmentspanel: some View {
        Listitemlabel(
            keyortitle: LANGUAGE_EQUIPMENT,
            value: exercise.displayequipments(preference),
            showarrow: false
        ) {
        }
        .background {
            NORMAL_BG_CARD_COLOR
        }
    }

    var targetareapanel: some View {
        Listitemlabel(
            keyortitle: "targetarea",
            value: exercise.displaytargetarea(preference),
            showarrow: false
        ) {
        }
        .background {
            NORMAL_BG_CARD_COLOR
        }
    }

    var logcontentpanel: some View {
        Listitemlabel(
            keyortitle: "logcontent",
            value: preference.language(exercise.exercise.logtype.rawValue),
            showarrow: false
        ) {
        }
        .background {
            NORMAL_BG_CARD_COLOR
        }
    }
    
    var weightmultiplyerpanel: some View {
        Listitemlabel(
            keyortitle: "volumemultiplier",
            value: "x\(preference.language(exercise.exercise.weighttype.label))",
            showarrow: false
        ) {
        }
        .background {
            NORMAL_BG_CARD_COLOR
        }
    }
    

    var weightmultiplyerpaneldesc: some View {
        VStack(alignment: .leading, spacing: 15) {
            bartitle("note")

            let _name = preference.language("volumemultiplier")
            let _explaintext = preference.languagewithplaceholder("volumemultiplierdesc", firstletteruppercase: false, value: _name)

            Text(_explaintext)
                .lineLimit(10)
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.leading)
                .lineSpacing(10)

            Divider().padding(.vertical, 10)

            let _explainexampletext = preference.languagewithplaceholder("volumemultiplierexample", firstletteruppercase: false, value: _name)

            Text(_explainexampletext)
                .lineLimit(10)
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.leading)
                .lineSpacing(10)

            LocaleText("volumemultiplierexample2",
                       usefirstuppercase: false, linelimit: 10,
                       linespacing: 10
            )
        }
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
}
