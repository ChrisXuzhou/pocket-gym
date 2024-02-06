//
//  Programeach.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/30.
//

import SwiftUI

let TEMPLATE_HEADER_HEIGHT: CGFloat = 40

struct Programeachlabel_Previews: PreviewProvider {
    static var previews: some View {
        let mockedprogrameachlist = mockprogrameachlist()
        let mockedprogramlist = mockprogramlist()

        DisplayedView {
            VStack {
                Programeachlabel(
                    day: 1,
                    program: mockedprogramlist[0],
                    programeachs: mockedprogrameachlist,
                    editing: true,
                    unpack: false
                )

                Programeachlabel(
                    day: 1,
                    program: mockedprogramlist[0],
                    programeachs: mockedprogrameachlist,
                    unpack: false
                )
            }
        }
    }
}

class Showprogrameachaddview: ObservableObject {
    @Published var value: Bool = false
}

struct Programeachlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var day: Int
    var program: Program
    var programeachs: [Programeach]

    var editing: Bool = false
    var unpack: Bool = true

    var programeachdeleted: ((_ programeachid: Int64) -> Void)?
    var programeachadded: ((_ routineid: Int64, _ day: Int) -> Void)?

    @StateObject var showprogrameachaddview = Showprogrameachaddview()

    func routinelabel(_ programeach: Programeach) -> some View {
        HStack(alignment: .center) {
            let workoutid = programeach.workoutid
            if let _workout = AppDatabase.shared.queryworkout(workoutid) {
                /*
                 Routinelabel(
                     _workout,
                     unpacked: unpack,
                     showmorebutton: false,
                     showuseroutinebutton: false,
                     spacing: true,
                     fontcolor: NORMAL_LIGHTER_COLOR,
                     backgroundcolor: Color.clear
                 )
                 */
            }

            if editing {
                Button {
                    if let _programeachdeleted = programeachdeleted {
                        _programeachdeleted(programeach.id!)
                    }
                } label: {
                    Delete(fontsize: 19)
                        .frame(height: 25)
                        .frame(height: TEMPLATE_HEADER_HEIGHT)
                }
            }
        }
        /*
         .background(
             NORMAL_GRAY_COLOR.opacity(0.2)
         )
         .clipShape(RoundedRectangle(cornerRadius: 10))
         */
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                if programeachs.isEmpty {
                    restlabel
                } else {
                    ForEach(programeachs, id: \.id) {
                        programeach in

                        routinelabel(programeach)
                    }

                    SPACE
                }
            }
            .frame(minHeight: 80)

            if editing {
                addworkoutbutton
                    .padding(.top)
            }
        }
    }
}

extension Programeachlabel {
    var restlabel: some View {
        HStack {
            SPACE

            Coffee(imgsize: 16)

            LocaleText("dayoff")
                .font(
                    .system(size: DEFINE_FONT_SMALL_SIZE)
                )

            SPACE
        }
        .foregroundColor(NORMAL_GRAY_COLOR)
        .padding(.horizontal)
    }
}

extension Programeachlabel {
    /*
     * operation related.
     */
    func deleteprogrameach(_ programeach: Programeach) {
        try! AppDatabase.shared.deleteprogrameach(programeach: programeach)
    }

    /*
     * routine selected.
     */
    func routineselected(_ routineid: Int64) {
        if let _programeachadded = programeachadded {
            _programeachadded(routineid, day)
        }
    }

    var addworkoutbutton: some View {
        Addatemplatebutton(showaddatemplateview: $showprogrameachaddview.value)
            .fullScreenCover(isPresented: $showprogrameachaddview.value) {
                NavigationView {
                    Routinelistselectsheet(
                        present: $showprogrameachaddview.value,
                        routineselected: routineselected
                    )
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                }
            }
    }
}
