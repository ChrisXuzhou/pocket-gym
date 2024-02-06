//
//  Routinelogcontent.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/8.
//

import Foundation
import SwiftUI

let DEFAULT_ROUTINE_CONTENT_EACH_WIDTH: CGFloat = (UIScreen.width - 110) / 3
let DEFAULT_ROUTINE_CONTENT_EACH_FONTSIZE: CGFloat = DEFINE_FONT_SIZE
let DEFAULT_ROUTINE_CONTENT_EACH_HEIGHT: CGFloat = 40

struct Routinelogcontent: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var viewmodel: Routineviewmodel
    @EnvironmentObject var workoutmodel: Workoutandeachlogmodel

    // @StateObject var model: Logcontentmodel

    init(
        batcheachlog: Batcheachlogwrapper,
        eachwidth: CGFloat = DEFAULT_ROUTINE_CONTENT_EACH_WIDTH,
        eachfontsize: CGFloat = DEFAULT_ROUTINE_CONTENT_EACH_FONTSIZE) {
        // _model = StateObject(wrappedValue: Logcontentmodel(batcheachlog))

        self.eachwidth = eachwidth
        self.eachfontsize = eachfontsize
    }

    var eachwidth: CGFloat
    var eachfontsize: CGFloat

    @FocusState private var repeatsfocused: Bool
    var repsview: some View {
        HStack {
            /*

                 HighlightTextField(
                     text: $model.repeats.onChange({ newrepeats in
                         Workoutcache.shared.exerciseid = model.batcheachlog.exerciseid
                         Workoutcache.shared.reps = newrepeats
                     }),
                     keyboardtype: .numberPad,
                     fontsize: eachfontsize - 2,
                     onEditingChanged: { begin in
                         if !begin {
                             model.saverepeats()
                         }
                     }
                 )
                 .focused($repeatsfocused)
                 .id(model.repeatsid)

             */
        }
        .frame(width: eachwidth, height: DEFAULT_ROUTINE_CONTENT_EACH_HEIGHT)
        .contentShape(Rectangle())
        .onTapGesture {
            repeatsfocused = true
        }
    }

    @FocusState private var weightfocused: Bool
    var weightview: some View {
        HStack {
            /*
             HighlightTextField(
                 text: $model.weight.onChange({ newweight in
                     Workoutcache.shared.exerciseid = model.batcheachlog.exerciseid
                     Workoutcache.shared.weight = newweight
                 }),
                 keyboardtype: .decimalPad,
                 fontsize: eachfontsize - 2,
                 onEditingChanged: { begin in
                     if !begin {
                         model.saveweight()
                     }
                 }
             )
             .focused($weightfocused)
             .id(model.weightid)

             */
        }
        .multilineTextAlignment(.center)
        .keyboardType(.decimalPad)
        .frame(width: eachwidth, height: DEFAULT_ROUTINE_CONTENT_EACH_HEIGHT)
        .contentShape(Rectangle())
        .onTapGesture {
            weightfocused = true
        }
    }

    var reststr: String {
        var _reststr = ""
        /*

         if let _rest: Int = model.batcheachlog.rest {
             _reststr = _rest.displayminuts
         }

         if _reststr.isEmpty {
             _reststr = "-"
         }

          */

        return _reststr
    }

    @FocusState private var resttimefocused: Bool
    var resttimelabel: some View {
        HStack {
            /*

             HighlightTextField(
                 text: $model.resttime,
                 keyboardtype: .numberPad,
                 fontsize: eachfontsize - 2,
                 onEditingChanged: { begin in
                     if !begin {
                         model.saveresttime()
                     }
                 }
             )
             .focused($resttimefocused)
             .id(model.resttimeid)

             */
        }
        .frame(width: eachwidth, height: DEFAULT_ROUTINE_CONTENT_EACH_HEIGHT)
        .contentShape(Rectangle())
        .onTapGesture {
            resttimefocused.toggle()
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            // let _type: Logtype = model.type
            let _type: Logtype = .repsandweight

            repsview.frame(width: eachwidth)

            if _type == .repsandweight {
                weightview.frame(width: eachwidth)
            } else {
                SPACE.frame(width: eachwidth)
            }

            if workoutmodel.workout.isfinished {
                resttimelabel.frame(width: eachwidth)
            }
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.7))
        .frame(height: DEFAULT_ROUTINE_CONTENT_EACH_HEIGHT)
    }
}
