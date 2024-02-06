//
//  Batcheachloglabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import SwiftUI

let BATCH_EACHLOG_LABEL_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE - 5
let BATCH_EACHLOG_NUMBER_WIDTH: CGFloat = 35

let LOG_FINSH_WIDTH: CGFloat = 35
let LOG_LABEL_HEIGHT: CGFloat = 50

struct Batcheachloglabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var workoutmodel: Workoutmodel
    @EnvironmentObject var batchmodel: Batchmodel
    
    /*
     * variables
     */
    @StateObject var selecttype = Viewopenswitch()
    @StateObject var values: Logvalue
    
    @ObservedObject var batcheachlog: Batcheachlogwrapper
    
    init(batcheachlog: Batcheachlogwrapper) {
        self.batcheachlog = batcheachlog
        self._values = StateObject(wrappedValue: Logvalue(batcheachlog))
    }

    var contentlabels: some View {
        HStack(alignment: .center, spacing: 0) {
            numberlabel

            SPACE

            Logcontent(batcheachlog: batcheachlog)

            SPACE

            SPACE.frame(width: LOG_FINSH_WIDTH)
        }
        .padding(.leading, 7)
    }

    var body: some View {
        ZStack {
            contentlabels

            oplabel
        }
        .environmentObject(values)
        .frame(height: LOG_LABEL_HEIGHT)
    }
}

/*
 * view related.
 */
extension Batcheachloglabel {
    var numberlabel: some View {
        ZStack {
            let _batcheachlog = batcheachlog.batcheachlog
            let type = _batcheachlog.oftype

            Button {
                selecttype.value = true
            } label: {
                HStack {
                    if type == .workout {
                        FinishedCircle(i: _batcheachlog.num + 1, finished: false)
                    }

                    if type != .workout {
                        Textlabelshape(text: "\(type.rawValue)short", color: type.color)
                    }
                }
                .frame(width: BATCH_EACHLOG_NUMBER_WIDTH)
            }
            .confirmationDialog("", isPresented: $selecttype.value) {
                Button("\(preference.language("normalset"))") {
                    changetype(.workout)
                }
                Button("\(preference.language("warmupset"))") {
                    changetype(.warmup)
                }
                Button("\(preference.language("dropset"))") {
                    changetype(.drop)
                }
                Button("\(preference.language("delete"))", role: .destructive) {
                    batchmodel.deletebatcheachlog(batcheachlog)
                }
            }
        }
    }

    var oplabel: some View {
        HStack(spacing: 0) {
            SPACE
            
            Logfinshbutton(eachlog: batcheachlog)
                    
        }
        .padding(.trailing, 5)
        .padding(.horizontal, 5)
    }
}


/*
 * action related.
 */
extension Batcheachloglabel {
    func changetype(_ type: Batchtype) {
        batcheachlog.batcheachlog.type = type
        
        batchmodel.refreshpreviousrecord()

        DispatchQueue.global().async {
            try! AppDatabase.shared.savebatcheachlog(&batcheachlog.batcheachlog)
        }
    }
}
