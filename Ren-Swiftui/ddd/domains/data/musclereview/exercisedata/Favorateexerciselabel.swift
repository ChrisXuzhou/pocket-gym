//
//  Favorateexerciselabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/9.
//

import SwiftUI

struct Favorateexerciselabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            HStack(spacing: 0) {
                Favorateexerciselabel(30001, covered: true)
                Favorateexerciselabel(30001, covered: true)
            }
        }
    }
}

let FAVOURATE_LABEL_WIDTH: CGFloat = 120
let FAVOURATE_LABEL_HEIGHT: CGFloat = 70

struct Favorateexerciselabel: View {

    var exercise: Newdisplayedexercise?
    var covered: Bool

    init(_ exerciseid: Int64, covered: Bool) {
        if let _def = AppDatabase.shared.queryNewexercisedef(exerciseid: exerciseid) {
            exercise = Newdisplayedexercise(_def)
        }
        
        self.covered = covered
    }

    var contentview: some View {
        VStack {
            if let _exercise = exercise {
                Exerciselabelvideo(exercise: _exercise,
                                   lablewidth: FAVOURATE_LABEL_WIDTH,
                                   lableheight: FAVOURATE_LABEL_HEIGHT
                )
            }
        }
    }

    var overlayed: some View {
        ZStack {
            // NORMAL_BG_CARD_COLOR.opacity(0.5)

            Check(finished: true, fontsize: 30)
                //.offset(y: 10)
        }
    }

    var body: some View {
        ZStack {
            contentview

            if covered {
                overlayed
            }
        }
    }
}
