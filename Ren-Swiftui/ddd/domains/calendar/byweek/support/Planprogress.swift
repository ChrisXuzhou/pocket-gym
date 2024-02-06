//
//  Planprogress.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/20.
//

import SwiftUI

struct Planprogress_Previews: PreviewProvider {
    static var previews: some View {
        let mockedplan = mockplan()
        let mockedplantask = mockplantasks()

        DisplayedView {
            Planprogress(mockedplan.id!)
        }
    }
}

func mockplan() -> Plan {
    try! AppDatabase.shared.deleteplan(id: -1)

    var plan = Plan(id: -1, programid: -1, programname: "push/pull/legs")
    try! AppDatabase.shared.saveplan(&plan)

    return plan
}

let PLAN_PROGRESS_BAR_HEIGHT: CGFloat = 8
let PLAN_PROGRESS_HEIGHT: CGFloat = 90

struct Planprogress: View {
    @ObservedObject var model: Planprogressmodel

    init(_ planid: Int64) {
        model = Planprogressmodel(planid)
    }

    var progressbarview: some View {
        HStack {
            if model.progress.1 > 0 {
                ZStack {
                    GeometryReader {
                        reader in

                        let width = reader.size.width
                        let height = PLAN_PROGRESS_BAR_HEIGHT

                        RoundedRectangle(cornerRadius: 3)
                            .frame(width: width, height: height)
                            .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)

                        let overlayedwidth: CGFloat = width * Double(model.progress.0) / Double(model.progress.1)

                        RoundedRectangle(cornerRadius: 3)
                            .frame(width: overlayedwidth, height: height)
                            .foregroundColor(NORMAL_GREEN_COLOR)
                    }
                }
                .frame(height: PLAN_PROGRESS_BAR_HEIGHT)
            }
        }
    }

    var planoverview: some View {
        VStack(spacing: 0) {
            let _p = model.progress

            HStack(spacing: 2) {
                VStack(alignment: .leading) {
                    if let _plan = model.plan {
                        LocaleText(_plan.programname ?? "")
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                            .foregroundColor(NORMAL_COLOR)
                    }
                }

                SPACE
            }
            .padding(.bottom)

            HStack {
                LocaleText("completed")

                Process(first: _p.0,
                        second: _p.1, firstfontsize: DEFINE_FONT_SMALL_SIZE,
                        secondfontsize: DEFINE_FONT_SMALL_SIZE,
                        fontcolor: NORMAL_LIGHTER_COLOR
                )

                SPACE
            }
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 4))
            .padding(.bottom, 5)

            progressbarview
        }
        .frame(height: PLAN_PROGRESS_HEIGHT)
    }

    var body: some View {
        VStack {
            if let _plan = model.plan {
                VStack {
                    planoverview
                }
                .padding(.horizontal)
                .background(
                    Imageplanlabelbackground(_plan.id!,
                                             _plan.programid)
                )
            }
        }
    }
}
