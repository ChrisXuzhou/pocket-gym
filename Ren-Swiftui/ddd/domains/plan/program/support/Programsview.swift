//
//  Programsview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//

import SwiftUI

struct Programsview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Programsview()
        }
    }
}

struct Programsview: View {
    @Environment(\.presentationMode) var present
    @StateObject var model = Programsviewmodel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            upheader
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 5) {
                    section(.beginner)
                    section(.intermediate)
                    section(.advanced)
                }
            }
        }
    }
}

extension Programsview {
    var upheader: some View {
        HStack(spacing: 10) {
            Button {
                present.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }

            SPACE

            LocaleText("programs")
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            SPACE.frame(width: 18)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(NORMAL_BG_COLOR)
    }

    func section(_ level: Programlevel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let programs = model.level2programlist[level] {
                HStack {
                    LocaleText(level.rawValue)
                        .font(.system(size: FOLDER_TITLE_FONT).bold())
                        .frame(alignment: .leading)
                        .lineLimit(1)
                        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
                        .padding(.vertical, 5)

                    SPACE
                }
                .frame(height: FOLDER_HEIGHT)
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 5) {
                        let orderedprograms = programs.sorted { l, r in
                            l.programname > r.programname
                        }

                        ForEach(orderedprograms, id: \.id) {
                            program in

                            Programlabel(program: program)
                        }
                    }
                }
                .padding(.leading, 10)
            }
        }
    }
}
