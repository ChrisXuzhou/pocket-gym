//
//  Routinebetaexercisedefpanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/30.
//
import SwiftUI

/*
 struct Routinebetaexercisedefpanel_Previews: PreviewProvider {
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
             VStack(spacing: 30) {
                 Routinebetaexercisedefpanel(
                     editing: true,
                     displayoverloadingbutton: false,
                     batchexercisedef:
                     Routinebetaexercisedef(mockbatchexercisedef),
                     fontsize: DEFINE_FONT_SIZE
                 )

                 Routinebetaexercisedefpanel(
                     batchexercisedef:
                     Routinebetaexercisedef(mockbatchexercisedef)
                 )
             }
         }
     }
 }
  */

/*
 var showprogressbutton: Bool
 self.showprogressbutton = showprogressbutton
 showprogressbutton: Bool = true,
 */
struct Routinebetaexercisedefpanel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var editing: Bool
    var displayexercisename: Bool
    var displayoverloadingbutton: Bool

    @ObservedObject var batchexercisedef: Routinebetaexercisedef

    init(
        editing: Bool = false,
        displayexercisename: Bool = true,
        displayoverloadingbutton: Bool = true,
        batchexercisedef: Routinebetaexercisedef,
        fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE + 1) {
        self.editing = editing
        self.displayexercisename = displayexercisename
        self.displayoverloadingbutton = displayoverloadingbutton

        self.batchexercisedef = batchexercisedef

        videolabel = AnyView(
            VStack {
                if let _exercise = batchexercisedef.batchexercisedef.ofexercisedef {
                    Exerciselabelvideo(
                        exercise: _exercise,
                        showlink: true,
                        showexercisedetailink: true,
                        lablewidth: 120,
                        lableheight: 60
                    )
                }
            }
        )

        self.fontsize = fontsize
    }

    /*
     * function variables
     */
    let videolabel: AnyView
    let lock = NSLock()

    var namefontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE
    var namefontcolor: Color = NORMAL_LIGHT_TEXT_COLOR

    var fontsize: CGFloat
    var fontcolor: Color = NORMAL_LIGHTER_COLOR

    @FocusState private var setsfocused: Bool
    @FocusState private var minrepsfocused: Bool
    @FocusState private var maxrepsfocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            exercisenamelabel

            HStack(spacing: 5) {
                videolabel

                if editing {
                    setsandrepeatslabel
                } else {
                    shortsetsandrepeatslabel
                }

                SPACE
            }
        }
    }
}

/*
 * to display
 */
extension Routinebetaexercisedefpanel {
    var exercisenamelabel: some View {
        HStack {
            if displayexercisename {
                if let _exercisedef = batchexercisedef.batchexercisedef.ofexercisedef {
                    LocaleText(_exercisedef.realname)
                        .font(.system(size: namefontsize))
                        .foregroundColor(namefontcolor)
                }
            }

            SPACE
        }
    }

    var buttonslabel: some View {
        HStack(spacing: 10) {
            Overloadingbutton(batchexercisedef: batchexercisedef.batchexercisedef)
        }
        .foregroundColor(NORMAL_BUTTON_COLOR)
    }

    var shortsetsandrepeatslabel: some View {
        HStack {
            LocaleText(batchexercisedef.displayedstr(preference: preference))
                .font(.system(size: fontsize - 1))
                .foregroundColor(fontcolor)
                .padding(.leading, 10)
        }
        .frame(minWidth: 100, minHeight: 40)
    }
}

/*
 * templates as label
 */
extension Routinebetaexercisedefpanel {
    var setslabel: some View {
        HStack {
            TextField(
                "\(batchexercisedef.batchexercisedef.sets ?? 0)",
                text: $batchexercisedef.batchsets.onChange({ newvalue in
                    let _sets = Int(newvalue) ?? 0
                    batchexercisedef.batchexercisedef.sets = _sets
                }),
                onEditingChanged: { editing in
                    if !editing {
                        /*
                             let _sets = Int(batchexercisedef.batchsets) ?? 0
                             batchexercisedef.batchexercisedef.sets = _sets
                         */
                    }
                }
            )
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .focused($setsfocused)
        }
        .foregroundColor(fontcolor)
        .font(.system(size: fontsize).bold())
        .frame(width: TEMPLATE_INPUT_WIDTH)
        .contentShape(Rectangle())
        .onTapGesture {
            setsfocused = true
        }
    }

    var minrepslabel: some View {
        HStack {
            TextField("\(batchexercisedef.batchexercisedef.minreps ?? 0)",
                      text: $batchexercisedef.minreps.onChange({ newvalue in
                          let _minreps = Int(newvalue) ?? 0
                          batchexercisedef.batchexercisedef.minreps = _minreps
                      }),
                      onEditingChanged: { editing in
                          if !editing {
                              /*

                                   let _minreps = Int(batchexercisedef.minreps) ?? 0
                                   batchexercisedef.batchexercisedef.minreps = _minreps
                               */
                          }
                      }
            )
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .focused($minrepsfocused)
        }
        .foregroundColor(fontcolor)
        .font(.system(size: fontsize).bold())
        .frame(width: TEMPLATE_INPUT_WIDTH)
        .contentShape(Rectangle())
        .onTapGesture {
            minrepsfocused = true
        }
    }

    var maxrepslabel: some View {
        HStack {
            TextField("\(batchexercisedef.batchexercisedef.maxreps ?? 0)",
                      text: $batchexercisedef.maxreps.onChange({ newvalue in
                          let _maxreps = Int(newvalue) ?? 0
                          batchexercisedef.batchexercisedef.maxreps = _maxreps
                      }),
                      onEditingChanged: { editing in
                          if !editing {
                              /*
                               let _maxreps = Int(batchexercisedef.maxreps) ?? 0
                               batchexercisedef.batchexercisedef.maxreps = _maxreps
                               */
                          }
                      }
            )
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .focused($maxrepsfocused)
        }
        .foregroundColor(fontcolor)
        .font(.system(size: fontsize).bold())
        .frame(width: TEMPLATE_INPUT_WIDTH)
        .contentShape(Rectangle())
        .onTapGesture {
            maxrepsfocused = true
        }
    }

    var setsandrepeatslabel: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            setslabel

            LocaleText("sets")

            Text(",")

            minrepslabel

            Text("~")

            maxrepslabel

            LocaleText("reps")

            SPACE
        }
        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
        .font(.system(size: fontsize - 4))
    }
}
