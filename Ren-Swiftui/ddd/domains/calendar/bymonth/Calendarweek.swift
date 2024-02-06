//
//  Calendarweek.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/29.
//

import SwiftUI
import GRDB

struct Calendarweek_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

extension AppDatabase {
    func observeunfinishedworkouts(
        interval: DateInterval,
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Workout]) -> Void
    ) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Workout
                    .filter((interval.start ... interval.end).contains(Column("workday")))
                    .filter([Stats.inplan.rawValue, Stats.progressing.rawValue].contains(Column("stats")))
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
    
    func observefinishedmuscles(
        interval: DateInterval,
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Analysisedmuscle]) -> Void
    ) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Analysisedmuscle
                    .filter((interval.start ... interval.end).contains(Column("workday")))
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class Calendarweekmodel: ObservableObject {
    var day: Date
    var interval: DateInterval

    /*
     * history
     */
    var muscles: [Analysisedmusclewrapper] = []
    var analysiseddictionary: [Int: [Analysisedmusclewrapper]] = [:]

    /*
     * plans
     */
    var workouts: [Workoutwrapper] = []
    var plandictionary: [Int: [Workoutwrapper]] = [:]

    init(_ day: Date) {
        self.day = day

        let end = Calendar.current.date(byAdding: .day, value: +7, to: day) ?? day
        interval = DateInterval(start: day, end: end)
        
        observeunfinished()
        observefinished()
    }
    
    /*
     * observe
     */
    var finishedobserved: DatabaseCancellable?
    var unfinishedobserved: DatabaseCancellable?
    
    private func observeunfinished() {
        unfinishedobserved = AppDatabase.shared.observeunfinishedworkouts(
            interval: interval,
            onError: { error in fatalError("unexpected error: \(error)") },
            onChange: { [weak self] workouts in
                guard let self = self else {
                    return
                }
                
                self.workouts = workouts.map({ Workoutwrapper($0) })
                self.plandictionary = Dictionary(grouping: self.workouts, by: { $0.value.workday?.day ?? 0 })
                
                self.objectWillChange.send()
            })
    }
    
    private func observefinished() {
        finishedobserved = AppDatabase.shared.observefinishedmuscles(
            interval: interval,
            onError: { error in fatalError("unexpected error: \(error)") },
            onChange: { [weak self] muscles in
                guard let self = self else {
                    return
                }
                
                self.muscles = muscles.map({ Analysisedmusclewrapper($0)  })
                self.analysiseddictionary = Dictionary(grouping: self.muscles, by: { $0.analysised.workday.day })
                
                self.objectWillChange.send()
            })
    }
}

struct Calendarweek: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var model: Calendarbymonthmodel

    /*
     * variables
     */
    @StateObject var weekmodel: Calendarweekmodel

    init(day: Date) {
        _weekmodel = StateObject(wrappedValue: Calendarweekmodel(day))
    }

    var dayNum: Int {
        Calendar.current.component(.day, from: weekmodel.day)
    }

    var monthNum: Int {
        Calendar.current.component(.month, from: weekmodel.day)
    }

    var weekleadbar: some View {
        VStack {
            SPACE

            if dayNum < 8 {
                Text("\(preference.language("\(monthNum)month"))".uppercased())
                    .tracking(0)
                    .lineLimit(1)
                    .rotationEffect(.degrees(-90))
                    .fixedSize()
                    .frame(width: 24, height: 100)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1, design: .rounded))
                    .foregroundColor(preference.theme)
                    .padding(.leading, 6)
            }

            SPACE
        }
        .frame(width: 30)
        .background(
            monthNum.color
        )
    }

    var body: some View {
        HStack(spacing: 0) {
            weekleadbar

            WeekView(week: weekmodel.day) { day in
                
                let _d = day.day
                let _workouts = weekmodel.plandictionary[_d] ?? []
                let _muscles = weekmodel.analysiseddictionary[_d] ?? []
                
                Calendarday(
                    day: day,
                    workouts: _workouts, muscles: _muscles
                )
            }
            .environmentObject(weekmodel)
        }
        .frame(height: CALENDAR_ITEM_HEIGHT)
    }
}
