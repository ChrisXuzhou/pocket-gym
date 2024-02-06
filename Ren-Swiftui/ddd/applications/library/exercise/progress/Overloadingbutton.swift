//
//  Progressconfigbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/24.
//


import SwiftUI

struct Overloadingbutton_Previews: PreviewProvider {
    static var previews: some View {
        let mockedexercise = mockbatchexercisedef()
        DisplayedView {
            Overloadingbutton(
                batchexercisedef: mockedexercise
            )
        }
    }
}

func mockbatchexercisedef() -> Batchexercisedef {
    Batchexercisedef(workoutid: -1,
                     batchid: -1,
                     exerciseid: 6003, order: 0)
}

func mockbatchexercisedefs() -> [Batchexercisedef] {
    [
        Batchexercisedef(workoutid: -1,
                         batchid: -1,
                         exerciseid: 6003, order: 0),
        Batchexercisedef(workoutid: -1,
                         batchid: -1,
                         exerciseid: 7009, order: 0),
        Batchexercisedef(workoutid: -1,
                         batchid: -1,
                         exerciseid: 7010, order: 0),
        Batchexercisedef(workoutid: -1,
                         batchid: -1,
                         exerciseid: 7006, order: 0),
        Batchexercisedef(workoutid: -1,
                         batchid: -1,
                         exerciseid: 7003, order: 0),
        Batchexercisedef(workoutid: -1,
                         batchid: -1,
                         exerciseid: 9004, order: 0)
    
    ]
}

class Showprogressconfigsheet: ObservableObject {
    @Published var value = false
}

struct Overloadingbutton: View {
    var batchexercisedef: Batchexercisedef

    @StateObject var showprogressconfigsheet = Showprogressconfigsheet()

    var body: some View {
        Button {
            showprogressconfigsheet.value.toggle()
        } label: {
            Programshape(size: 18)
                .foregroundColor(NORMAL_BUTTON_COLOR)
        }
        .sheet(isPresented: $showprogressconfigsheet.value) {
            Overloadingsettingsheet(
                present: $showprogressconfigsheet.value,
                batchexercisedef: batchexercisedef
            )
        }
    }
}
