//
//  Favorateexerciselabellist.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/9.
//

import SwiftUI

struct Favorateexerciselabellist_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Favorateexerciselabellist(muscleid: "chest",
                                      exerciseidlist: [4001, 4002])
                .environmentObject(Favourateexercisemodel())
        }
    }
}

struct Favorateexerciselabellist: View {
    @ObservedObject var model: Favourateexercisemodel = Favourateexercisemodel()

    let muscleid: String
    let exerciseidlist: [Int64]

    var intersectlist: [Int64] {
        let set = Set(exerciseidlist)
        return Array(set.intersection(model.markedexerciseidset))
    }

    var body: some View {
        VStack(alignment: .leading) {
            let exerciseidlist = model.exerciseidlist(muscleid)

            if !exerciseidlist.isEmpty {
                VStack(alignment: .leading) {
                    HStack(spacing: 3) {
                        Pentagram().foregroundColor(.yellow)

                        Process(first: intersectlist.count,
                                second: exerciseidlist.count,
                                firstfontsize: DEFINE_FONT_SMALL_SIZE,
                                secondfontsize: DEFINE_FONT_SMALL_SIZE,
                                fontcolor: NORMAL_LIGHTER_COLOR
                        )

                        LocaleText("favoriteexercisescovered")

                        SPACE
                    }
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
                    .padding(.vertical)
                    .padding(.horizontal)

                    HStack {
                        if !exerciseidlist.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(exerciseidlist, id: \.self) {
                                        exerciseid in

                                        let covered = self.exerciseidlist.contains(exerciseid)
                                        Favorateexerciselabel(
                                            exerciseid,
                                            covered: covered
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Emptycontentpanel()
                        }

                        SPACE
                    }
                    .frame(height: 80)
                }
            } else {
                Divider()
            }
        }
    }
}
