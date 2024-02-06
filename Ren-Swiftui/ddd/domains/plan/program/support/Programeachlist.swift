//
//  PlanprogrameachlistView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/23.
//

import SwiftUI

struct Programeachlist_Previews: PreviewProvider {
    static var previews: some View {
        let mockedprogrameachlist = mockprogrameachlist()
        let mockedprogramlist = mockprogramlist()

        DisplayedView {
            ScrollView {
                Programeachlist()
            }
            .environmentObject(
                Programmodel(mockedprogramlist[0])
            )
        }

        DisplayedView {
            ScrollView {
                Programeachlist()
            }
            .environmentObject(
                Programmodel(mockedprogramlist[0])
            )
        }
    }
}

struct Programeachlist: View {
    /*
     var editing: Bool = false
     var unpack: Bool = true
     */

    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Programmodel

    func daynumberview(_ daynum: Int) -> some View {
        HStack {
            let raw = preference.language("daynumber")
            LocaleText(
                raw.replacingOccurrences(of: "{}", with: "\(daynum)")
            )
            .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1).bold())
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            
            
            
            SPACE
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            let daynum2programeachlist: [Int: [Programeach]] = model.daynum2programeachlist

            if model.program.days > 0 {
                ForEach(1 ... model.program.days, id: \.self) {
                    day in

                    let programeachs: [Programeach] = daynum2programeachlist[day] ?? []

                    VStack(alignment: .leading) {
                        daynumberview(day)
                            

                        Programeachlabel(day: day,
                                         program: model.program,
                                         programeachs: programeachs,
                                         editing: false,
                                         unpack: true
                        )
                        

                        if day < model.program.days {
                            Divider()
                                .padding(5)
                        }
                    }
                }
            }

            SPACE.frame(height: 20)
        }
    }
}

extension Programeditormodel {
    func refreshprogrameach() {
        daynum2programeachlist = Dictionary(grouping: programeachlist, by: { $0.daynum })
    }

    func deleteprogrameach(_ programid: Int64) {
        for idx in 0 ..< programeachlist.count {
            let each: Programeach = programeachlist[idx]

            if each.id == programid {
                deletedprogrameachlist.append(each)

                programeachlist.remove(at: idx)
                refreshprogrameach()

                break
            }
        }
    }

    func newedprogrameachid() -> Int64 {
        addedprogrameachid = addedprogrameachid - 1
        return addedprogrameachid
    }

    func addprogrameach(_ routineid: Int64, _ day: Int) {
        let _newedprogrameachid = newedprogrameachid()
        let newedprogrameach = Programeach(id: _newedprogrameachid,
                                           programid: program!.id!, workoutid: routineid, daynum: day)

        addedprogrameachlist.append(newedprogrameach)
        programeachlist.append(newedprogrameach)
        refreshprogrameach()
    }
}

struct Programeacheditlist: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Programeditormodel

    func daynumberview(_ daynum: Int) -> some View {
        HStack {
            let raw = preference.language("daynumber")
            LocaleText(
                raw.replacingOccurrences(of: "{}", with: "\(daynum)")
            )
            .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1).bold())
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            SPACE
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            let daynum2programeachlist: [Int: [Programeach]] = model.daynum2programeachlist

            if let _program = model.program {
                VStack(alignment: .leading, spacing: 15) {
                    if model.days > 0 {
                        ForEach(1 ... model.days, id: \.self) {
                            day in

                            let programeachs: [Programeach] = daynum2programeachlist[day] ?? []

                            VStack(alignment: .leading) {
                                daynumberview(day)
                                    

                                Programeachlabel(day: day,
                                                 program: _program,
                                                 programeachs: programeachs,
                                                 editing: true,
                                                 unpack: false,
                                                 programeachdeleted: model.deleteprogrameach(_:),
                                                 programeachadded: model.addprogrameach(_:_:)
                                )
                                

                                if day < _program.days {
                                    Divider().padding(.horizontal, 5)
                                }
                            }
                        }
                    }
                }
                .id(model.days)
            }

            SPACE.frame(height: 20)
        }
    }
}

func mockprogrameachlist() -> [Programeach] {
    try! AppDatabase.shared.deleteprogrameach(id: -1)
    try! AppDatabase.shared.deleteprogrameach(id: -2)
    try! AppDatabase.shared.deleteprogrameach(id: -3)

    var programeachlist: [Programeach] = [
        Programeach(id: -1, programid: -1, workoutid: -1, daynum: 1),
        Programeach(id: -2, programid: -1, workoutid: -1, daynum: 3),
        Programeach(id: -3, programid: -1, workoutid: -1, daynum: 5),
    ]

    try! AppDatabase.shared.saveprogrameachlist(&programeachlist)

    return programeachlist
}
