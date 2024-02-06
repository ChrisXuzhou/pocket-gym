//
//  Keyexercisepanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/4.
//

import SwiftUI

struct Keyexercisepanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Librarybetaview(showbackbutton: false)
                .navigationBarHidden(true)
        }
        
        DisplayedView {
            ScrollView(.vertical, showsIndicators: false) {
                Keyexercisepanel(
                    keyexercise: preparekeyexercises()
                )
            }
        }
    }
}

func preparekeyexercises() -> Keyexercise {
    let _exercises = AppDatabase.shared.queryNewexercisedefs("curl", equipmentid: "dumbbell").map({ Newdisplayedexercise($0) })
    return Keyexercise(key: "curl", exercises: _exercises)
}

struct Keyexercisepanel: View {
    @ObservedObject var keyexercise: Keyexercise

    /*
     * function variables
     */
    var keyfontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE + 1
    var keycolor = NORMAL_LIGHT_TEXT_COLOR

    var body: some View {
        VStack(spacing: 5) {
            keyname

            keyexercisescontent
        }
        .padding(.vertical, 5)
        /*
         .clipShape(RoundedRectangle(cornerRadius: 10))
         .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 5)
         .background(
             NORMAL_BG_CARD_COLOR.opacity(0.3)
         )
         */
    }
}

extension Keyexercisepanel {
    var keyname: some View {
        HStack {
            SPACE
            LocaleText(keyexercise.key)
                .font(.system(size: keyfontsize, design: .rounded).italic())
                .foregroundColor(keycolor)
            SPACE
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }

    var keyexercisescontent: some View {
        VStack {
            let columns = [
                GridItem(.fixed(RIGHT_GRID_WIDTH)),
                GridItem(.fixed(RIGHT_GRID_WIDTH)),
                GridItem(.fixed(RIGHT_GRID_WIDTH)),
            ]

            LazyVGrid(columns: columns, spacing: 7) {
                ForEach(0 ..< keyexercise.exercises.count, id: \.self) { idx in

                    if let _e = keyexercise.exercises[idx] {
                        Exercisepanel(exercise: _e)
                    }
                }
            }
        }
    }
}
