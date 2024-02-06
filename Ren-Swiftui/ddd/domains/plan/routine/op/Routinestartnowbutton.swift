//
//  Planworkoutstartbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/1.
//


import SwiftUI
struct Routinestartnowbutton_Previews: PreviewProvider {
    static var previews: some View {
        let mockedworkout = mockworkout()
        let model = Workoutandeachlogmodel(mockedworkout)
        let trainingmodel = Trainingmodel()

        DisplayedView {
            VStack {
                SPACE
                Routinestartnowbutton()
            }
            .environmentObject(model)
            .environmentObject(trainingmodel)
        }
    }
}

struct Routinestartnowbutton: View {
    @EnvironmentObject var permit: Permit
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var templatemodel: Workoutandeachlogmodel

    @EnvironmentObject var preference: PreferenceDefinition

    var buttonview: some View {
        Button {
            trainingmodel.confirmedstartnow(templatemodel.workout)
        } label: {
            HStack {
                SPACE
                LocaleText("startnow")
                    .foregroundColor(.white)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                SPACE
            }
            .frame(height: MIN_DOWN_BUTTON_HEIGHT)
            .background(
                preference.theme.ignoresSafeArea()
            )
        }
    }

    var body: some View {
        VStack {
            if !templatemodel.isfinished {
                buttonview
            }
        }
    }
}
