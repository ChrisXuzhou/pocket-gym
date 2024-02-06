//
//  Calendardaycontent.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/30.
//

import SwiftUI

struct Daymusclecards_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Calendarview()
                .environmentObject(Calendarfocusedday())
        }
    }
}

struct Daymusclecards: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @StateObject var model: Calendaradaybetamodel

    let fontsize: CGFloat = 10.5

    init(_ day: Date, workouts: [Workoutwrapper]) {
        _model = StateObject(wrappedValue: Calendaradaybetamodel(day, workouts: workouts))
    }

    var body: some View {
        verticalcontent
    }
}

extension Daymusclecards {
    func daymuscle(
        _ muscleid: String, finished: Bool = false,
        isrounded: Bool = true
    ) -> some View {
        Musclelabel(
            muscleid: muscleid, finished: finished,
            fontsize: fontsize,
            isrounded: isrounded
        )
    }

    var verticalcontent: some View {
        VStack(alignment: .center, spacing: 1) {
            ForEach(model.finishedmuscleids, id: \.self) {
                muscleid in
                daymuscle(muscleid, finished: true)
            }

            ForEach(model.todomuscleids, id: \.self) {
                muscleid in
                daymuscle(muscleid, finished: false)
            }

            if model.showmore {
                daymuscle("more", finished: false)
            }

            if model.showempty {
                daymuscle("empty", finished: false)
            }

            SPACE
        }
    }
}
