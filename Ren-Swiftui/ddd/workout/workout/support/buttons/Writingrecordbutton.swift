//
//  Writingrecordbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

extension Workoutmodel: Texteditor {
    func save(_ newvalue: String?) {
        var workout = self.workout
        workout.trainingrecord = newvalue
        try! AppDatabase.shared.saveworkout(&workout)
    }
}

struct Writingrecordbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    

    @EnvironmentObject var workoutmodel: Workoutmodel

    @State var writingtrainingnote: Bool = false
    var writingbutton: some View {
        HStack {
            SPACE
            Button {
                writingtrainingnote.toggle()
            } label: {
                Pencile()
                    .foregroundColor(
                        preference.theme
                    )
            }
            SPACE
        }
    }

    var body: some View {
        writingbutton
            .fullScreenCover(isPresented: $writingtrainingnote) {
                TexteditorView(
                    value: workoutmodel.workout.trainingrecord ?? "",
                    title: preference.language(LANGUAGE_TRAINING_EDIT_TRAININGRECORD),
                    editor: workoutmodel
                )
            }
    }
}
