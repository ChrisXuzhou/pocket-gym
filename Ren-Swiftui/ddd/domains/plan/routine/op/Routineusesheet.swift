//
//  Routineusesheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/31.
//


import SwiftUI

struct Routineusesheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Routineusesheet(present: .constant(false), routine: Routine(mockworkout()))
        }
    }
}

let START_BAR_HEIGHT: CGFloat = 250
let BUTTON_START_WIDTH: CGFloat = (UIScreen.width - 20 ) / 2

struct Routineusesheet: View {

    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool
    @StateObject var templatemodel: Workoutandeachlogmodel

    /*
     * variables
     */
    @StateObject var showresultreminder = Viewopenswitch()
    @StateObject var presentquestion = Viewopenswitch()

    init(present: Binding<Bool>, routine: Routine) {
        _present = present
        _templatemodel = StateObject(wrappedValue: Workoutandeachlogmodel(routine.routine))
    }

    func startnow() {
        let newedworkout =
            templatemodel
                .planer
                .buildaplanworkout(preference.ofweightunit, planday: Date())

        _ = trainingmodel.opentraining(newedworkout, preference: preference)

        present = false
    }

    func makeaplan() {
        presentquestion.value.toggle()
    }

    var starbarview: some View {
        HStack(spacing: 10) {
            SPACE

            Button {
                makeaplan()
            } label: {
                Imagetextbutton(
                    img: Image("schedule").renderingMode(.template),
                    imgsize: 26,
                    imgcolor: NORMAL_COLOR,
                    text: "makeaplan",
                    width: 120
                )
                .frame(width: BUTTON_START_WIDTH)
            }
            .fullScreenCover(isPresented: $presentquestion.value) {
                Routinemakeaplanquestion(present: $presentquestion.value) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showresultreminder.value = true
                    }
                }
                .environmentObject(templatemodel)
                .environmentObject(preference)
            }

            Divider().padding(.horizontal, 5).frame(height: 40)

            Button {
                startnow()
            } label: {
                Imagetextbutton(
                    img: Image(systemName: "play.circle.fill"),
                    imgsize: 23,
                    imgcolor: NORMAL_COLOR,
                    text: "startnow",
                    width: 120
                )
                .frame(width: BUTTON_START_WIDTH)
            }

            SPACE
        }
        .frame(height: START_BAR_HEIGHT)
    }

    var body: some View {
        VStack {
            starbarview
        }
        .alert("\(preference.language("workoutsetreminder"))", isPresented: $showresultreminder.value) {
            Button("OK", role: .cancel) { }
        }
    }
}
