//
//  Libraryadddownbar.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

struct Libraryadddownbar_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

let LIBRARY_DOWNBAR_HEIGHT: CGFloat = MIN_DOWN_BUTTON_HEIGHT
let LIBRARY_ADDBUTTON_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE
let LIBRARY_BUTTON_CORNER_RADIUS: CGFloat = 10

let LIBRARY_DOWNBAR_WIDTH: CGFloat = UIScreen.width - 20
let LIBRARY_ADDBUTTONS_SPACING: CGFloat = 0
let LIBRARY_ADDBUTTON_EXTEND_WIDTH: CGFloat = LIBRARY_DOWNBAR_HEIGHT
let LIBRARY_ADDBUTTON_WIDTH: CGFloat = LIBRARY_DOWNBAR_WIDTH - LIBRARY_ADDBUTTON_EXTEND_WIDTH - LIBRARY_ADDBUTTONS_SPACING

struct Libraryadddownbar: View {
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var libraryusage: Libraryusage

    var workoutaction: Workoutaction

    var body: some View {
        VStack(spacing: 0) {
            LOCAL_DIVIDER
            
            HStack(spacing: 0) {
                superbutton

                addbutton
            }
        
        }
        .frame(height: MIN_DOWN_BUTTON_HEIGHT)
        .background(
            NORMAL_BG_COLOR.ignoresSafeArea()
        )
        /*
         .clipShape(
             RoundedRectangle(cornerRadius: LIBRARY_BUTTON_CORNER_RADIUS)
         )
         */
        //.padding(.horizontal, 10)
        //.shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 25)

    }
}

extension Libraryadddownbar {
    /*
     * add button
     */
    var addbutton: some View {
        Button {
            add()
        } label: {
            HStack {
                SPACE

                LocaleText("add")
                    .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())
                    .foregroundColor(preference.theme)

                SPACE
            }
            .frame(height: MIN_DOWN_BUTTON_HEIGHT)
        }
    }

    /*
     * batch button
     */
    var superbutton: some View {
        ZStack {
            let count = (libraryusage.libraryaction as! Libraryaddexerciseaction).selectedarray.count
            let disabled = count < 2

            Button {
                batchadd()
            } label: {
                HStack {
                    SPACE
                    Text("\(preference.language("super")) x \(count)")
                        .foregroundColor(disabled ? NORMAL_BUTTON_COLOR : preference.theme)
                        .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())
                    SPACE
                }
                .frame(height: MIN_DOWN_BUTTON_HEIGHT)
                /*
                 .clipShape(
                     RoundedRectangle(cornerRadius: LIBRARY_BUTTON_CORNER_RADIUS)
                 )
                 */
            }
            .disabled(disabled)
        }
    }
}

extension Libraryadddownbar {

    func add() {
        workoutaction.select(
            (libraryusage.libraryaction as! Libraryaddexerciseaction).selectedarray,
            batchtype: .workout,
            weightunit: trainingpreference.weightunit
        )
    }

    func batchadd() {
        workoutaction.batchselect(
            (libraryusage.libraryaction as! Libraryaddexerciseaction).selectedarray,
            batchtype: .workout,
            weightunit: trainingpreference.weightunit
        )
    }
}
