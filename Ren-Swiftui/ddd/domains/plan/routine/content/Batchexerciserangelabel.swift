//
//  Batchexerciserangelabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/23.
//

import FloatingLabelTextFieldSwiftUI
import SwiftUI
/*
 
 struct Batchexerciserangelabel_Previews: PreviewProvider {
     static var previews: some View {
         let mockedexercise = mockexercisedef()

         let mockbatchexercisedef =
             Batchexercisedef(workoutid: -1,
                              batchid: -1,
                              exerciseid: mockedexercise.id!,
                              order: 0,
                              minreps: 89, maxreps: 120,
                              sets: 50
             )

         DisplayedView {
             VStack {
                 Batchexerciserangelabel(
                     batchexercisedef: mockbatchexercisedef,
                     sets: .constant(55),
                     minreps: .constant(55),
                     maxreps: .constant(90)
                 )

                 Batchexerciserangelabel(
                     editing: true,
                     batchexercisedef: mockbatchexercisedef,
                     sets: .constant(55),
                     minreps: .constant(55),
                     maxreps: .constant(90)
                 )

                 /*

                  Batchexerciserangelabel(
                      showexercisename: true,
                      batchexercisedef: mockbatchexercisedef
                  )

                  Batchexerciserangelabel(
                      batchexercisedef: mockbatchexercisedef
                  )

                  Batchexerciserangelabel(
                      showexercisename: true,
                      showprogressbutton: true,
                      batchexercisedef: mockbatchexercisedef
                  )
                  */
             }
         }
     }
 }
 
 */

let TEMPLATE_DESCRIPTION_FONT_SIZE: CGFloat = 18
let TEMPLATE_INPUT_WIDTH: CGFloat = 43

/*
 var showprogressbutton: Bool
 self.showprogressbutton = showprogressbutton
 showprogressbutton: Bool = true,
 */

class Batchexerciserangelabelmodel: ObservableObject {
    @Published var batchsets: String
    @Published var maxreps: String
    @Published var minreps: String

    var batchexercisedef: Batchexercisedef
    var exercisedef: Newdisplayedexercise?

    init(_ batchexercisedef: Batchexercisedef) {
        self.batchexercisedef = batchexercisedef
        exercisedef = batchexercisedef.ofexercisedef

        batchsets = "\(batchexercisedef.sets ?? 0)"
        maxreps = "\(batchexercisedef.maxreps ?? 0)"
        minreps = "\(batchexercisedef.minreps ?? 0)"
    }

    func displayedstr(preference: PreferenceDefinition) -> String {
        var template: String = ""
        if minreps == maxreps {
            template = preference.language("batchdescriptshort2", firstletteruppercase: false)
            template = template.replacingOccurrences(of: "{REPS}", with: "\(minreps)")
        } else {
            template = preference.language("batchdescriptfull2", firstletteruppercase: false)
            template = template.replacingOccurrences(of: "{REPS_MIN}", with: "\(minreps)")
            template = template.replacingOccurrences(of: "{REPS_MAX}", with: "\(maxreps)")
        }

        template = template.replacingOccurrences(of: "{SETS}", with: "\(batchsets)")
        return template
    }
}

struct Batchexerciserangelabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var editing: Bool
    var displayexercisename: Bool
    var displayoverloadingbutton: Bool

    @Binding var sets: Int?
    @Binding var minreps: Int?
    @Binding var maxreps: Int?

    init(
        editing: Bool = false,
        displayexercisename: Bool = false,
        displayoverloadingbutton: Bool = true,
        batchexercisedef: Batchexercisedef,
        sets: Binding<Int?>, minreps: Binding<Int?>, maxreps: Binding<Int?>) {
        self.editing = editing
        self.displayexercisename = displayexercisename
        self.displayoverloadingbutton = displayoverloadingbutton

        _sets = sets
        _minreps = minreps
        _maxreps = maxreps

        _model = StateObject(wrappedValue: Batchexerciserangelabelmodel(batchexercisedef))
        videolabel = AnyView(
            VStack {
                if let _exercise = batchexercisedef.ofexercisedef {
                    Exerciselabelvideo(
                    // Exerciselabelimgandvideo(
                        exercise: _exercise,
                        showlink: true,
                        showexercisedetailink: true,
                        lablewidth: 120,
                        lableheight: 60
                    )
                }
            }
        )
    }

    let videolabel: AnyView
    @StateObject var model: Batchexerciserangelabelmodel

    let lock = NSLock()

    @FocusState private var isfocused1: Bool
    @FocusState private var isfocused2: Bool
    @FocusState private var isfocused3: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            exercisenamelabel

            HStack(spacing: 5) {
                videolabel

                if editing {
                    setsandrepeatslabel
                } else {
                    shortsetsandrepeatslabel
                }

                SPACE

                if displayoverloadingbutton {
                    buttonslabel
                }
            }
        }
    }
}

/*
 * templates as label
 */
extension Batchexerciserangelabel {
    var exercisenamelabel: some View {
        HStack {
            if displayexercisename {
                if let _exercisedef = model.exercisedef {
                    LocaleText(_exercisedef.realname)
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2))
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                }
            }

            SPACE
        }
    }

    var buttonslabel: some View {
        HStack(spacing: 10) {
            Overloadingbutton(batchexercisedef: model.batchexercisedef)
        }
        .foregroundColor(NORMAL_BUTTON_COLOR)
    }

    var shortsetsandrepeatslabel: some View {
        HStack {
            LocaleText(model.displayedstr(preference: preference))
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .padding(.leading, 10)
        }
    }

    var setsandrepeatslabel: some View {
        HStack(alignment: .center, spacing: 0) {
            TextField("",
                      text: $model.batchsets,
                      onEditingChanged: { _ in
                          _savesets()
                      }
            )
            .focused($isfocused1)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .multilineTextAlignment(.center)
            .font(.system(size: TEMPLATE_DESCRIPTION_FONT_SIZE))
            .frame(width: TEMPLATE_INPUT_WIDTH, height: 50)
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                isfocused1 = true
            })
            .keyboardType(.numberPad)

            LocaleText("sets")
                .offset(y: 3)

            Text(",")
                .offset(y: 3)

            TextField("",
                      text: $model.minreps,
                      onEditingChanged: { _ in
                          _saveminreps()
                      }
            )
            .focused($isfocused2)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .multilineTextAlignment(.center)
            .font(.system(size: TEMPLATE_DESCRIPTION_FONT_SIZE))
            .frame(width: TEMPLATE_INPUT_WIDTH, height: 50)
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                isfocused2 = true
            })
            .keyboardType(.numberPad)

            Text("~")
                .offset(y: 3)

            TextField("",
                      text: $model.maxreps,
                      onEditingChanged: { _ in
                          _savemaxreps()
                      }
            )
            .focused($isfocused3)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .multilineTextAlignment(.center)
            .font(.system(size: TEMPLATE_DESCRIPTION_FONT_SIZE))
            .frame(width: TEMPLATE_INPUT_WIDTH, height: 50)
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                isfocused3 = true
            })
            .keyboardType(.numberPad)

            LocaleText("reps")
                .offset(y: 3)

            SPACE
        }
        .foregroundColor(NORMAL_GRAY_COLOR)
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 4).bold())
    }
}

/*
 * functions
 */
extension Batchexerciserangelabel {
    func _savesets() {
        lock.lock()
        defer {
            lock.unlock()
        }

        let _sets: Int = Int(model.batchsets) ?? 0
        sets = _sets
        model.batchsets = "\(_sets)"

        model.batchexercisedef.sets = sets
        try! AppDatabase.shared.savebatchexercisedef(&model.batchexercisedef)
    }

    func _savemaxreps() {
        lock.lock()
        defer {
            lock.unlock()
        }

        let _maxreps: Int = Int(model.maxreps) ?? 0
        model.maxreps = "\(_maxreps)"
        maxreps = _maxreps

        model.batchexercisedef.maxreps = maxreps
        try! AppDatabase.shared.savebatchexercisedef(&model.batchexercisedef)
    }

    func _saveminreps() {
        lock.lock()
        defer {
            lock.unlock()
        }

        let _minreps: Int = Int(model.minreps) ?? 0
        model.minreps = "\(_minreps)"
        minreps = _minreps

        model.batchexercisedef.minreps = minreps
        try! AppDatabase.shared.savebatchexercisedef(&model.batchexercisedef)
    }
}

struct RoutineTextFieldStyle: FloatingLabelTextFieldStyle {
    func body(content: FloatingLabelTextField) -> FloatingLabelTextField {
        content
            .textAlignment(.leading)
            .textColor(NORMAL_LIGHTER_COLOR)
            .titleColor(.clear)
            .selectedTitleColor(.clear)
            .lineColor(.clear)
            .lineHeight(0)
            .selectedLineHeight(0)
            .selectedLineColor(.clear)
            .selectedTextColor(.blue)
            .isShowError(false)
    }
}
