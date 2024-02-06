//
//  Overloadingsettingsheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/24.
//

import FloatingLabelTextFieldSwiftUI
import SwiftUI

/*
 
 struct Overloadingsettingsheet_Previews: PreviewProvider {
     static var previews: some View {
         let mockedexercise = mockexercisedef()

         let mockbatchexercisedef =
             Batchexercisedef(workoutid: -1,
                              batchid: -1,
                              exerciseid: mockedexercise.id!,
                              order: 0,
                              minreps: 8, maxreps: 12,
                              sets: 5
             )

         DisplayedView {
             Overloadingsettingsheet(
                 present: .constant(true),
                 batchexercisedef: mockbatchexercisedef
             )
         }
     }
 }
 
 */

class Overloadingsettingmodel: ObservableObject {
    @Published var overloadingenabled: Bool
    @Published var increasingrate: Int
    @Published var succeedtimes: Int

    let rule: Progressrule

    init(_ exerciseid: Int64) {
        var rule: Progressrule? = AppDatabase.shared.queryprogressrule(exerciseid: exerciseid)

        if rule == nil {
            rule = Progressrule(exerciseid: exerciseid, increasing: false, increasedrate: 10, finisedtimestoincrease: 1)
        }

        let _rule = rule!

        overloadingenabled = _rule.increasing
        increasingrate = _rule.increasedrate
        succeedtimes = _rule.finisedtimestoincrease

        self.rule = _rule
    }

    func saveoverloadingsetting() {
        var _rule = rule
        try! AppDatabase.shared.saveprogressrule(&_rule)
    }
}

struct Overloadingsettingsheet: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool
    var batchexercisedef: Batchexercisedef

    @State var stringsets: String
    @State var stringmaxreps: String = "12"
    @State var stringminreps: String = "12"

    init(present: Binding<Bool>, batchexercisedef: Batchexercisedef) {
        _present = present
        self.batchexercisedef = batchexercisedef

        _model = StateObject(wrappedValue: Overloadingsettingmodel(batchexercisedef.exerciseid))

        _stringsets = .init(initialValue: "\(batchexercisedef.sets ?? 0)")
        _stringmaxreps = .init(initialValue: "\(batchexercisedef.maxreps ?? 0)")
        _stringminreps = .init(initialValue: "\(batchexercisedef.minreps ?? 0)")
    }

    @StateObject var model: Overloadingsettingmodel

    var body: some View {
        VStack(spacing: 0) {
            uptabview

            ScrollView(.vertical, showsIndicators: false) {
                exerciselabel

                noteslabel

                Overloadingsettingbar(
                    displayedsets: stringsets,
                    displayedmaxreps: stringmaxreps
                )
                .environmentObject(model)
                .background(
                    NORMAL_BG_CARD_COLOR
                )

                SPACE.frame(height: UIScreen.height / 5)
            }.padding(.top)
        }
        .onTapGesture {
            endtextediting()
        }
        .background {
            NORMAL_BG_COLOR.ignoresSafeArea()
        }
    }
}

extension Overloadingsettingsheet {
    func save() {
        model.saveoverloadingsetting()
    }

    var uptabview: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            Button {
                withAnimation {
                    save()
                    presentmode.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("save")
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
            }
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        .foregroundColor(NORMAL_COLOR)
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(
            NORMAL_BG_CARD_COLOR.ignoresSafeArea()
        )
    }
}

extension Overloadingsettingsheet {
    var exerciselabel: some View {
        VStack(alignment: .leading) {
            Batchexerciserangelabel(
                displayoverloadingbutton: false,
                batchexercisedef: batchexercisedef,
                sets: .constant(nil),
                minreps: .constant(nil),
                maxreps: .constant(nil)
            )
            .disabled(true)
            .padding()
        }
    }

    var noteslabel: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                bartitle("note")
                SPACE
            }

            VStack(alignment: .leading, spacing: 10) {
                // LocaleText("notecontent", usefirstuppercase: false).lineSpacing(5)

                Divider().padding(.vertical)

                LocaleText("noteappcando", usefirstuppercase: false, linespacing: 8).lineSpacing(5)
                
                // LocaleText("notesucceedtimes", usefirstuppercase: false).lineSpacing(5)
            }
            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
            .foregroundColor(NORMAL_LIGHTER_COLOR)
        }
        .padding()
    }
}

/*

 var setsview: some View {
     HStack {
         let text = preference.language("setsnumber")

         Listitemlabel(keyortitle: text) {
             FloatingLabelTextField(
                 $stringsets,
                 placeholder: "",
                 editingChanged: { changed in
                     if !changed {
                         savesets()
                         log("lost focus ...")
                     }
                 }
             ) {
                 savesets()
             }
             .textFont(.system(size: DEFINE_FONT_SIZE - 1))
             .floatingStyle(RecordTextFieldStyle())
             .keyboardType(.numberPad)
             .frame(width: 30, height: 40)
             .keyboardType(.decimalPad)
         }
         .background(NORMAL_BG_CARD_COLOR)
     }
 }

 var repsrangeview: some View {
     HStack {
         let text = preference.language("minreps")

         Listitemlabel(keyortitle: text) {
             FloatingLabelTextField(
                 $stringminreps,
                 placeholder: "",
                 editingChanged: { changed in
                     if !changed {
                         saveminreps()
                         log("lost focus ...")
                     }
                 }
             ) {
                 saveminreps()
             }
             .textFont(.system(size: DEFINE_FONT_SIZE - 1))
             .floatingStyle(RecordTextFieldStyle())
             .keyboardType(.numberPad)
             .frame(width: 30, height: 40)
             .keyboardType(.decimalPad)
         }

         Divider()

         let text = preference.language("maxreps")

         Listitemlabel(keyortitle: text) {
             FloatingLabelTextField(
                 $stringmaxreps,
                 placeholder: "",
                 editingChanged: { changed in
                     if !changed {
                         savemaxreps()
                         log("lost focus ...")
                     }
                 }
             ) {
                 savemaxreps()
             }
             .textFont(.system(size: DEFINE_FONT_SIZE - 1))
             .floatingStyle(RecordTextFieldStyle())
             .keyboardType(.numberPad)
             .frame(width: 30, height: 40)
             .keyboardType(.decimalPad)
         }
     }
     .frame(height: LIST_ITEM_HEIGHT)
     .background(NORMAL_BG_CARD_COLOR)
 }

 */
