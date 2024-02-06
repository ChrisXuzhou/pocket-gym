//
//  Libraryaddsheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

struct LibraryaddView_Previews: PreviewProvider {
    static var previews: some View {
        let mockedworkout = mockworkout() // mockemptyworkout()
        let mockedworkoutmodel = Workoutmodel(mockedworkout)

        DisplayedView {
            LibraryaddView(workoutaction: mockedworkoutmodel)
        }
    }
}

class Libraryaddexerciseaction {
    var selectedarray: [Newdisplayedexercise] = []

    func aexerciseseleted(_ exercise: Newdisplayedexercise) {
        if let _idx = selectedarray.firstIndex(of: exercise) {
            selectedarray.remove(at: _idx)
        } else {
            selectedarray.append(exercise)
        }
    }

    func isselected(_ exercise: Newdisplayedexercise) -> Bool {
        return selectedarray.contains(exercise)
    }
}

struct LibraryaddView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    
    @StateObject var usage: Libraryusage = Libraryusage(usage: .forselect, libraryaction: Libraryaddexerciseaction())

    /*
     * variables
     */
    var workoutaction: Workoutaction
    var callback: () -> Void = {}

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            

            VStack(spacing: 0) {
                Librarybetaview(showbackbutton: true, usage: usage, callback: callback)

                downbar
            }
        }
        .environmentObject(usage)
        .ignoresSafeArea(.keyboard)
    }
}


extension LibraryaddView {

    var downbar: some View {
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
            let count = (usage.libraryaction as! Libraryaddexerciseaction).selectedarray.count
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

extension LibraryaddView {

    func add() {
        workoutaction.select(
            (usage.libraryaction as! Libraryaddexerciseaction).selectedarray,
            batchtype: .workout,
            weightunit: trainingpreference.weightunit
        )
        
        callback()
    }

    func batchadd() {
        workoutaction.batchselect(
            (usage.libraryaction as! Libraryaddexerciseaction).selectedarray,
            batchtype: .workout,
            weightunit: trainingpreference.weightunit
        )
        
        callback()
    }
}

