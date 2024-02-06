//
//  ProgramLabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/21.
//

import GRDB
import SwiftUI

struct Programlabel_Previews: PreviewProvider {
    static var previews: some View {
        let mockedprograms: [Program] = mockprogramlist()
        let mockedprogrameachs = mockprogrameachlist()

        DisplayedView {
            VStack {
                Programlabel(program: mockedprograms[0])
            }
        }
    }
}

let SCHEME_LABEL_WIDTH: CGFloat = (UIScreen.width - 20 - 5) / 2
let SCHEME_LABEL_HEIGHT: CGFloat = 240
let SCHEME_LABEL_TEXT_HEIGHT: CGFloat = 110

struct Programlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @ObservedObject var model: Programlabelmodel

    var width: CGFloat

    init(program: Program?,
         width: CGFloat = SCHEME_LABEL_WIDTH) {
        model = Programlabelmodel(program)
        self.width = width
    }

    var program: Program? {
        model.program
    }

    var bgimgview: some View {
        VStack {
            if let _program = program {
                Imageplanbackground(secondid: _program.id!)
                    .frame(width: width, height: SCHEME_LABEL_HEIGHT)
                    .ignoresSafeArea()
            }
        }
    }

    var trainingcountview: some View {
        HStack(spacing: 5) {
            Text("\(model.programeachlist.count)")
            LocaleText("workout", lowercase: true)

            SPACE
        }
    }

    var descriptionview: some View {
        VStack {
            SPACE

            if let _program = program {
                VStack(alignment: .leading, spacing: 10) {
                    LocaleText(_program.programname)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1).bold())
                        .foregroundColor(NORMAL_LIGHTER_COLOR)

                    VStack(alignment: .leading, spacing: 3) {
                        LocaleText(_program.programlevel.rawValue)

                        trainingcountview
                    }

                    SPACE
                }
                .padding([.top, .horizontal], 10)
                .frame(height: SCHEME_LABEL_TEXT_HEIGHT)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1).bold())
                .foregroundColor(NORMAL_LIGHT_BUTTON_COLOR)
                .background(
                    NORMAL_BG_CARD_COLOR
                )
            }
        }
    }

    func deleteprogram() {
        if let _program = program {
            try! AppDatabase.shared.deleteprogram(program: _program)
            try! AppDatabase.shared.deleteprogrameach(programid: _program.id!)
        }
    }

    var modifyview: some View {
        VStack {
            HStack {
                SPACE
                Button {
                    deleteprogram()
                } label: {
                    Delete(fontsize: 18)
                        .foregroundColor(NORMAL_RED_COLOR)
                        .padding(3)
                        .background(
                            Circle().foregroundColor(NORMAL_LIGHTEST_GRAY_COLOR)
                        )
                }
                .padding()
            }
            SPACE
        }
    }

    // @State var showprogramdetail = false
    var contentview: some View {
        ZStack {
            bgimgview

            descriptionview
        }
        .frame(width: width, height: SCHEME_LABEL_HEIGHT)
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
        .clipped()
    }

    // (isActive: $showprogramdetail)
    var _bodyview: some View {
        NavigationLink {
            /*

                 NavigationLazyView(
                 )
             */

            Programview(program: program!, useprogram: true)
                .environmentObject(preference)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)

        } label: {
            contentview
        }
        .isDetailLink(false)
    }

    var body: some View {
        HStack {
            if program != nil {
                _bodyview
            }
        }
    }
}
