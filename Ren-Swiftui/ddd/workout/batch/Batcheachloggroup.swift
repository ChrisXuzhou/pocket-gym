//
//  Batcheachloggroup.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import SwiftUI

struct Batcheachloggroup: View {
    @EnvironmentObject var batchmodel: Batchmodel
    @EnvironmentObject var logfocused: Logfocused

    let num: Int
    let orderedbatcheachloglist: [Batcheachlogwrapper]

    func batcheachloglabel(_ batcheachlog: Batcheachlogwrapper) -> some View {
        ZStack {
            Batcheachloglabel(batcheachlog: batcheachlog)
        }
        .transition(.move(edge: .trailing))
        .contentShape(Rectangle())
        .onTapGesture {
            focus(batcheachlog)
        }
        .onDelete {
            batchmodel.deletebatcheachlog(batcheachlog)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< orderedbatcheachloglist.count, id: \.self) {
                idx in

                let batcheachlog = orderedbatcheachloglist[idx]

                batcheachloglabel(batcheachlog)
                    .id(batcheachlog.batcheachlog.id ?? -1)
            }
        }
    }
}

/*
 * view related.
 */
extension Batcheachloggroup {
    func itembackgroudcolor(_ batcheachlog: Batcheachlogwrapper) -> Color {
        
        return batchmodel.isfinished ? NORMAL_GREEN_COLOR.opacity(0.1) : Color.clear
        
    }
}

extension Batcheachloggroup {
    var isfinished: Bool {
        for each in orderedbatcheachloglist {
            if !each.batcheachlog.isfinished {
                return false
            }
        }
        return true
    }

    var displayednum: Int {
        num + 1
    }
}

/*
 * action
 */
extension Batcheachloggroup {
    func focus(_ batcheachlog: Batcheachlogwrapper) {
        logfocused.focus(batcheachlog)

        endtextediting()
    }
}
