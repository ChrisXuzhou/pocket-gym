//
//  Exerciselabellistsection.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/23.
//

import SwiftUI

let SECTION_HORIZONTAL_SPACING: CGFloat = 15
let SECTION_HEIGHT: CGFloat = 60

struct Exerciselabellistsection: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var model: Exerciselabellistmodel
    @EnvironmentObject var exerciseactioncontext: Exerciseactioncontext

    let equipment: String

    private func _keyword(_ id: String) -> String {
        let _id = id // preference.language(id)

        let words = _id.components(separatedBy: "_")
        return String(words.last ?? "empty")
    }

    var exerciselist: [Exercisedef] {
        if let exerciselist = model.equipment2exerciselist[equipment] {
            let ordered = exerciselist.sorted(by: { l, r in

                let lk = _keyword(l._id)
                let rk = _keyword(r._id)

                if lk != rk {
                    return lk < rk
                } else {
                    return l._id < r._id
                }
            })

            return ordered
        }
        return []
    }

    init(equipment: String) {
        self.equipment = equipment.lowercased()

        log("[init] exercise section ...")
    }

    var packbutton: some View {
        Button {
            tapfunction()
        } label: {
            Image(systemName: showdetail ? "chevron.up" : "chevron.down")
                .foregroundColor(
                    showdetail ? NORMAL_BUTTON_COLOR : preference.themeprimarycolor
                )
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        }
    }

    @State var showdetail = true
    var sectionheaderview: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                LocaleText(equipment)
                    .font(
                        .system(size: DEFINE_FONT_SMALLER_SIZE)
                            .bold()
                    )
                    .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.8))
                    .padding(.leading, 3)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tapfunction()
                    }

                SPACE

                packbutton
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tapfunction()
                    }
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 12)
        .frame(height: SECTION_HEIGHT)
        .background(
            NORMAL_BG_COLOR.opacity(0.9)
        )
    }

    func tapfunction() {
        showdetail.toggle()
    }

    func sectionexerciseview(_ exercise: Exercisedef) -> some View {
        HStack {
            /*
             Exerciselabel(
                 exercise: exercise,
                 isselected: exerciseactioncontext.isselected(exercise),
                 ismarked: exerciseactioncontext.ismarked(exercise),
                 aware: exerciseactioncontext
             )
             
             */
        }
    }

    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                if showdetail {
                    let _exerciselist: [Exercisedef] = exerciselist

                    ForEach(_exerciselist, id: \.id) {
                        exercise in

                        sectionexerciseview(exercise)
                        
                    }
                }
            }
            header: {
                sectionheaderview.id(equipment)
            }
        }
    }
}

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .opacity,
            removal: .move(edge: .trailing))
    }
}

struct LabelButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: DEFINE_FONT_SIZE).bold())
            .foregroundColor(NORMAL_LIGHTER_COLOR)
    }
}
