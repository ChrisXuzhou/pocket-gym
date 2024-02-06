//
//  Trainingoverview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/3.
//

import SwiftUI

struct Trainingoverview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Trainingoverview(present: .constant(true))
                .environmentObject(Trainingmodel())
        }
    }
}

let TRAINING_OVERVIEW_DIVIDER_HEIGHT: CGFloat = 30
let OVERVIEW_BUTTON_WIDTH: CGFloat = 80

let IMAGE_BUTTON_WIDTH: CGFloat = (UIScreen.width - 30) / 5

struct Trainingoverview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    @Binding var present: Bool

    @State var useonermcalculater = false
    var onermbutton: some View {
        Button {
            useonermcalculater.toggle()
        } label: {
            Imagetextbutton(
                img: Image("onerm"),
                imgsize: 32,
                imgcolor: preference.theme,
                text: "1rm",
                textuppercase: true,
                width: IMAGE_BUTTON_WIDTH
            )
        }
        .fullScreenCover(isPresented: $useonermcalculater) {
            Onermcalculator(present: $useonermcalculater)
        }
    }

    @State var fatcalculator = false
    var fatbutton: some View {
        Button {
            fatcalculator.toggle()
        } label: {
            Imagetextbutton(
                img: Image("fat"),
                imgsize: 32,
                imgcolor: preference.theme,
                text: "bodyfat",
                width: IMAGE_BUTTON_WIDTH
            )
        }
        .fullScreenCover(isPresented: $fatcalculator) {
            Fatpercentcalculator(present: $fatcalculator)
        }
    }

    @State var bmicalculator = false
    var bmibutton: some View {
        Button {
            bmicalculator.toggle()
        } label: {
            Imagetextbutton(
                img: Image("bmi"),
                imgsize: 32,
                imgcolor: preference.theme,
                text: "bmi",
                textuppercase: true,
                width: IMAGE_BUTTON_WIDTH
            )
        }
        .fullScreenCover(isPresented: $bmicalculator) {
            Bmicalculator(present: $bmicalculator)
        }
    }

    @State var daylycaloriecalculator = false
    var daylycaloriebutton: some View {
        Button {
            daylycaloriecalculator.toggle()
        } label: {
            Imagetextbutton(
                img: Image("diet"),
                imgsize: 32,
                imgcolor: preference.theme,
                text: "daylycalorie",
                width: IMAGE_BUTTON_WIDTH
            )
        }
        .fullScreenCover(isPresented: $daylycaloriecalculator) {
            Dailycaloriecalculator(present: $daylycaloriecalculator)
        }
    }

    @State var burnedcaloriecalculator = false
    var burnedcaloriebutton: some View {
        Button {
            burnedcaloriecalculator.toggle()
        } label: {
            Imagetextbutton(
                img: Image("calorie"),
                imgsize: 32,
                imgcolor: preference.theme,
                text: "burnedcalorie",
                width: IMAGE_BUTTON_WIDTH
            )
        }
        .fullScreenCover(isPresented: $burnedcaloriecalculator) {
            Burnedcaloriecalculator(present: $burnedcaloriecalculator)
        }
    }

    var operationview: some View {
        VStack {
            HStack(spacing: 0) {
                burnedcaloriebutton
                daylycaloriebutton
                fatbutton

                bmibutton
                onermbutton
            }

            SPACE
        }
        .frame(height: 90)
    }

    func newaworkout() {
        present = false

        var newedworkout = Workout()
        try! AppDatabase.shared.saveworkout(&newedworkout)

        trainingmodel.confirmedstartnow(newedworkout)
    }

    @State var showselectroutineview: Bool = false
    var startbar: some View {
        HStack {
            SPACE
            Button {
                showselectroutineview = true
            } label: {
                Labelbutton(img: Image("makeaplan"),
                            bgcolor: NORMAL_GREEN_COLOR,
                            text: "usetemplate",
                            subtext: "usetemplatedesc"
                )
            }

            SPACE

            Button {
                newaworkout()
            } label: {
                Labelbutton(img: Image("exercise"),
                            imgsize: 32,
                            bgcolor: preference.theme,
                            text: "startaexercise",
                            subtext: "startaexercisedesc"
                )
            }

            SPACE
        }
    }

    var finishedbar: some View {
        Finishedworkouts()
            .padding(.bottom, 10)
    }

    var body: some View {
        VStack(spacing: 0) {
            finishedbar

            startbar

            Divider().padding()

            operationview

            SPACE.frame(maxHeight: 60)
        }
        .transition(.move(edge: .bottom))
    }
}
