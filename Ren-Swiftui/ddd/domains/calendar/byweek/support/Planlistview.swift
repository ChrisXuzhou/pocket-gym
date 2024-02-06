//
//  PlanlistView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/21.
//

import SwiftUI
import SwiftUIPager

struct PlanlistView_Previews: PreviewProvider {
    static var previews: some View {
        let plantasklist = mockplanandtasklist()

        DisplayedView {
            ZStack {
                NORMAL_BG_COLOR.ignoresSafeArea()

                Planlistview(plantasklist)
            }
        }
    }
}

func mockplanandtasklist() -> [Plantask] {
    try! AppDatabase.shared.deleteplan(id: -1)
    try! AppDatabase.shared.deleteplan(id: -2)

    try! AppDatabase.shared.deleteplantask(planid: -1)
    try! AppDatabase.shared.deleteplantask(planid: -2)

    let programname = "push/pull/legs"
    let today = Date()

    var plans = [
        Plan(id: -1, programid: -1, programname: programname),
        Plan(id: -2, programid: -1, programname: programname),
    ]

    try! AppDatabase.shared.saveplan(&plans[0])
    try! AppDatabase.shared.saveplan(&plans[1])

    var plantasks = [
        Plantask(id: -1, planid: -1,
                 programname: programname, workoutid: -1),
        Plantask(id: -2, planid: -2,
                 programname: programname, workoutid: -1),
    ]

    try! AppDatabase.shared.saveplantask(&plantasks[0])
    try! AppDatabase.shared.saveplantask(&plantasks[1])

    return plantasks
}

struct Planlistview: View {
    @StateObject var page: Page = .first()
    var plantasklist: [Plantask]

    init(_ plantasklist: [Plantask]) {
        self.plantasklist = plantasklist
    }

    var pagesview: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(plantasklist, id: \.id) {
                    task in

                    if let planid = task.planid {
                        Planprogress(planid).id(planid)
                    }
                }
            }
        }
    }

    var previousornextbuttons: some View {
        HStack {
            if page.index != 0 {
                Button {
                    withAnimation {
                        page.update(.previous)
                    }
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                }
            }

            SPACE

            if page.index < (plantasklist.count - 1) {
                Button {
                    withAnimation {
                        page.update(.next)
                    }
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                }
            }
        }
        .foregroundColor(NORMAL_GRAY_COLOR.opacity(0.5))
        .font(.system(size: 24))
        .padding(.horizontal, 5)
    }

    var body: some View {
        ZStack {
            pagesview

            // previousornextbuttons
        }
    }
}
