//
//  Routinemakeaplanquestion.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/31.
//


import SwiftUI

struct Routinemakeaplanquestion_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Routinemakeaplanquestion(present: .constant(true))
        }
    }
}

struct Routinemakeaplanquestion: View {
    @EnvironmentObject var templatemodel: Workoutandeachlogmodel
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool
    @State var startdate: Date = Date()
    
    var callback: () -> Void = {}

    /*
     * variables
     */
    @StateObject var showselectdateview = Viewopenswitch()
    @StateObject var showresultreminder = Viewopenswitch()

    var uptab: some View {
        VStack {
            UptabHeaderView(present: $present) {
            }
            .padding(.horizontal)

            SPACE
        }
    }

    var selectionview: some View {
        VStack {
            Exercisevideo()
                .padding(.bottom)

            Answerinput(
                answer: startdate.displayedyearmonthdate,
                descriptor: "",
                focused: showselectdateview.value
            )
            .contentShape(Rectangle())
            .onTapGesture {
                showselectdateview.value = true
            }
            .sheet(isPresented: $showselectdateview.value) {
                DatepickerView(selecteddate: $startdate)
                    .environmentObject(preference)
            }
            .padding(.horizontal)
        }
    }

    func confirm() {
        templatemodel
            .planer
            .buildplantask(day: startdate, weightunit: preference.ofweightunit)
    }

    var confirmbutton: some View {
        Button {
            present = false

            DispatchQueue.global().async {
                confirm()
            }
            
            callback()
            
        } label: {
            Floatingbutton(
                label: "confirm",
                disabled: false,
                color: preference.theme
            )
            .padding(.vertical, NORMAL_CUSTOMIZE_BUTTON_VSPACING).padding(.horizontal)
        }
    }

    var contentview: some View {
        VStack {
            SPACE.frame(height: MIN_UP_TAB_HEIGHT)

            Question("chooseyourtrainingdate")

            selectionview
                .padding(.vertical, NORMAL_CUSTOMIZE_UP_VSPACING)

            SPACE

            confirmbutton
        }
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            contentview

            uptab
        }
        .onTapGesture {
            endtextediting()
        }
        .ignoresSafeArea(.keyboard)
    }
}
