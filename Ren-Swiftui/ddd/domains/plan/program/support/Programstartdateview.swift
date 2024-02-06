//
//  Programstartdateview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/1.
//


import SwiftUI

struct Programstartdateview: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var programmodel: Programmodel

    @Binding var present: Bool
    @State var startdate: Date = Date()

    @StateObject var showselectdateview = Viewopenswitch()
    @StateObject var showresultreminder = Viewopenswitch()

    var uptab: some View {
        UptabHeaderView(present: $present) {
        }
        .padding(.horizontal)
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
            .padding(.horizontal, 10)
        }
    }

    func confirm() {
        programmodel.buildaplan(startdate, weightunit: preference.ofweightunit)
    }

    var confirmbutton: some View {
        Button {
            showresultreminder.value = true

            DispatchQueue.global().async {
                confirm()
            }

        } label: {
            Floatingbutton(
                label: "confirm",
                disabled: false,
                color: preference.theme
            )
            .padding(.vertical, NORMAL_CUSTOMIZE_BUTTON_VSPACING).padding(.horizontal)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            uptab

            Question("chooseyourstartdate")

            selectionview
                .padding(.vertical, NORMAL_CUSTOMIZE_UP_VSPACING)

            SPACE

            confirmbutton
        }
        .onTapGesture {
            endtextediting()
        }
        .ignoresSafeArea(.keyboard)
        /*
         .partialSheet(isPresented: $showresultreminder.value, iPhoneStyle: .themeStyle()) {
             Programstartedresult(present: $present, startdate: startdate)
         }
         */
    }
}

struct Programstartedresult: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var pageddomain: Pageddomain
    @EnvironmentObject var focusedday: Calendarfocusedday

    @Binding var present: Bool
    var startdate: Date
    var remindtext: String = "plansetreminder"

    var content: some View {
        VStack {
            LocaleText("donecheer")
                .font(.system(size: DEFINE_FONT_BIG_SIZE).bold())
                .foregroundColor(NORMAL_GREEN_COLOR)
                .padding(5)

            LocaleText(remindtext)
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                .padding(.vertical)

            SPACE

            HStack(spacing: 0) {
                Button {
                    present = false
                } label: {
                    LocaleText("cancel")
                }
                .frame(width: 150)

                Button {
                    present = false

                    DispatchQueue.main.async {
                        pageddomain.pageddomain = .calendar
                        focusedday.focus(startdate)
                    }

                } label: {
                    LocaleText("ok", uppercase: true)
                        .foregroundColor(preference.theme)
                }
                .frame(width: 150)
            }
            .font(.system(size: DEFINE_FONT_SIZE).bold())
            .foregroundColor(NORMAL_COLOR)
        }
        .padding(30)
        .frame(height: UIScreen.height / 3)
    }

    var body: some View {
        VStack {
            content
        }
    }
}
