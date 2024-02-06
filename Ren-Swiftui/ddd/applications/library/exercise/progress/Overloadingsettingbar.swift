//
//  Overloadingsettingbar.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/27.
//

import SwiftUI

let OVERLOADING_INCREASING_RATE: [Int] = [2, 3, 5, 8, 10, 15]
let OVERLOADING_SUCCEED_TIMES: [Int] = [1, 2, 3]

class Showincreasingrate: ObservableObject {
    @Published var value = false
}

class Showsucceedtimes: ObservableObject {
    @Published var value = false
}

/*
 .onChange({ newvalue in
     var rule = rule
     rule.increasedrate = newvalue
     try! AppDatabase.shared.saveprogressrule(&rule)
 })

 */

struct Overloadingsettingbar: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Overloadingsettingmodel

    let displayedsets: String
    let displayedmaxreps: String

    // exerciseid: Int64,
    init(displayedsets: String, displayedmaxreps: String) {
        self.displayedsets = displayedsets
        self.displayedmaxreps = displayedmaxreps
    }

    @StateObject var showincreasingrate = Showincreasingrate()
    @StateObject var showsucceedtimes = Showsucceedtimes()

    var divider: AnyView = AnyView(
        Divider()
    )

    var body: some View {
        VStack(alignment: .leading) {
            overloadingenabledlabel

            if model.overloadingenabled {
                Divider().padding(.horizontal)
                    .padding(.vertical, 0)

                notelabel

                increasingratelabel

                succeedtimeslabel
            }
        }
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }
}

extension Overloadingsettingbar {
    /*
     .onChange(
         { newvalue in
             var rule = rule
             rule.increasing = newvalue
             try! AppDatabase.shared.saveprogressrule(&rule)
         }
     )

     */
    var overloadingenabledlabel: some View {
        Listitemlabel(
            keyortitle: preference.language("enableoverloadinghelper")
        ) {
            Toggle(
                "", isOn: $model.overloadingenabled
            )
            .toggleStyle(
                SwitchToggleStyle(tint: preference.themeprimarycolor)
            )
        }
    }

    var increasingratelabel: some View {
        Listitemlabel(
            img: Image("data"),
            imgsize: 18,
            keyortitle: "increaserate") {
            Valuedescriptor(value: "\(model.increasingrate)", footer: "%")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showincreasingrate.value = true
        }
        .sheet(isPresented: $showincreasingrate.value) {
            Intseletctorsheet(
                selected: $model.increasingrate,
                rangelist: OVERLOADING_INCREASING_RATE,
                rangedescriptor: "%"
            )
        }
    }

    var succeedtimeslabel: some View {
        Listitemlabel(
            img: Image("schedule"),
            imgsize: 18,
            keyortitle: "successtimes") {
            Valuedescriptor(value: "\(model.succeedtimes)")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showsucceedtimes.value = true
        }
        .sheet(isPresented: $showsucceedtimes.value) {
            Intseletctorsheet(
                selected: $model.succeedtimes,
                rangelist: OVERLOADING_SUCCEED_TIMES,
                rangedescriptor: preference.language("times").lowercased()
            )
        }
    }

}

extension Overloadingsettingbar {
    var notetext: String {
        return preference.language("settingnote", firstletteruppercase: false)
            .replacingOccurrences(of: "{SET}", with: displayedsets)
            .replacingOccurrences(of: "{MAX REPS}", with: displayedmaxreps)
            .replacingOccurrences(of: "{SUCCESS TIMES}", with: "\(model.succeedtimes)")
            .replacingOccurrences(of: "{INCREASE PERCENT}", with: "\(model.increasingrate)")
    }

    var notelabel: some View {
        VStack(alignment: .leading, spacing: 8) {
            bartitle("note")

            LocaleText(notetext, linelimit: 4, linespacing: 8)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
                .lineSpacing(5)
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .padding(.horizontal)
    }
}
