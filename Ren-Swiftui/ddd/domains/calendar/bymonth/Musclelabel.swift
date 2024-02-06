//
//  Musclelabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/28.
//

import SwiftUI

struct Musclelabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }

        /*
         VStack {
             Musclelabel(muscleid: "chest", finished: false)

             Musclelabel(muscleid: "chest", finished: false)

             Musclelabel(muscleid: "chest")

         }
         */
    }
}

let CALENDAR_ACTIVITY_ITEM_HEIGHT: CGFloat = 15

struct Musclelabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var muscleid: String
    var finished: Bool = true
    var fontsize: CGFloat = 12
    var isrounded: Bool = true

    var body: some View {
        ZStack {
            if finished {
                label
            } else {
                label
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(preference.themesecondarycolor, lineWidth: 0.7)
                    }
            }
        }
    }

    var label: some View {
        VStack(alignment: .center, spacing: 0) {
            let colors: (Color, Color) = color(muscleid)
            let muscletag = preference.language(muscleid)
            let height: CGFloat = muscletag.count < 10 ? 14 : 25

            HStack(spacing: 1) {
                SPACE
                Text(muscletag.uppercased())
                    .tracking(0)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .lineSpacing(0)
                    .font(.system(size: fontsize, design: .rounded))
                    .foregroundColor(colors.0)
                    .minimumScaleFactor(0.01)
                SPACE
            }
            .padding(.horizontal, 1)
            .frame(height: height)
            .background(
                colors.1
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
            )
        }
    }

    func color(_ muscleid: String) -> (Color, Color) {
        if !finished {
            return (NORMAL_BUTTON_COLOR, Color.clear)
        }

        if let m = Librarynewdisplayedmuscle.shared.dictionary[muscleid] {
            let idx: Int64 = m.muscle.id ?? -1
            return (.white, ofcolor(idx))
        }

        return (.white, NORMAL_HEAT_COLOR)
    }
}
