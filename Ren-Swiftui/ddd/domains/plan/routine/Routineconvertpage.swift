//
//  Converttoroutinepage.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/31.
//

import SwiftUI

struct Routineconvertpage_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Routineconvertpage(present: .constant(false)) {
                _ in
            }
        }
    }
}

struct Routineconvertpage: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool
    @State var level: Programlevel?

    var callback: (_ level: Programlevel) -> Void

    init(present: Binding<Bool>,
         level: Programlevel? = nil,
         callback: @escaping (_ level: Programlevel) -> Void) {
        _present = present
        _level = .init(initialValue: level)

        self.callback = callback
        log("init fitness view")
    }

    var uptab: some View {
        UptabHeaderView(
            present: $present
        ) {
        }
        .padding(.horizontal)
    }

    var selectionview: some View {
        VStack {
            Answerselection(
                answer: Programlevel.beginner.rawValue,
                description: Programlevel.beginner.description,
                focused: level == .beginner
            )
            .onTapGesture {
                level = .beginner
            }

            Answerselection(
                answer: Programlevel.intermediate.rawValue,
                description: Programlevel.intermediate.description,
                focused: level == .intermediate
            )
            .onTapGesture {
                level = .intermediate
            }

            Answerselection(
                answer: Programlevel.advanced.rawValue,
                description: Programlevel.advanced.description,
                focused: level == .advanced
            )
            .onTapGesture {
                level = .advanced
            }
        }
        .padding(.horizontal)
    }

    func routineselected() {
        callback(level ?? .beginner)
        present = false
    }

    var nextbutton: some View {
        Button(
            action: {
                routineselected()
            }, label: {
                Floatingbutton(
                    label: "confirm",
                    disabled: level == nil,
                    color: preference.theme
                )
                .padding(.vertical, NORMAL_CUSTOMIZE_BUTTON_VSPACING).padding(.horizontal)
            }
        )
        .disabled(level == nil)
    }

    var body: some View {
        VStack(spacing: 0) {
            uptab

            Question("describeyourroutinelevel")
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .padding(.horizontal)

            selectionview.padding(.vertical, NORMAL_CUSTOMIZE_UP_VSPACING)

            SPACE

            nextbutton
        }
    }
}
