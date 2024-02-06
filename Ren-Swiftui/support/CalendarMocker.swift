import Foundation

func mockTodayAnalysisedmuscle() -> [Analysisedmuscle] {
    try! AppDatabase.shared.deleteAnalysisedmuscles(workoutid: -1)

    let today = Date()

    let severalDaysAgo = Calendar.current.date(byAdding: .hour, value: -3, to: today) ?? today
    let yestoday = Calendar.current.date(byAdding: .hour, value: -1, to: today) ?? today
    let tomorrow = Calendar.current.date(byAdding: .hour, value: -2, to: today) ?? today

    var analysisedlist: [Analysisedmuscle] = [
        /*

         Analysisedmuscle(createtime: today, workoutid: -1, muscle: "Chest",
                          primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),
         Analysisedmuscle(createtime: severalDaysAgo, workoutid: -1, muscle: "Back",
                          primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),
         Analysisedmuscle(createtime: yestoday, workoutid: -1, muscle: "Abs",
                          primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),
         Analysisedmuscle(createtime: tomorrow, workoutid: -1, muscle: "Back",
                          primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),
         Analysisedmuscle(createtime: tomorrow, workoutid: -1, muscle: "Quadriceps",
                          primaryExerciseCnt: 0, primaryVolume: 0, secondaryExerciseCnt: 5),

         */
    ]

    try! AppDatabase.shared.saveAnalysisedmuscles(&analysisedlist)
    return analysisedlist
}

func mockAnalysisedmuscle() -> [Analysisedmuscle] {
    try! AppDatabase.shared.deleteAnalysisedmuscles(workoutid: -1)

    let today = Date()

    let severalDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: today) ?? today
    let yestoday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today

    var analysisedlist: [Analysisedmuscle] = [
        /*

             Analysisedmuscle(createtime: today, workoutid: -1, muscle: "Chest",
                              primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),
             Analysisedmuscle(createtime: severalDaysAgo, workoutid: -1, muscle: "Back",
                              primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),
             Analysisedmuscle(createtime: yestoday, workoutid: -1, muscle: "Abs",
                              primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),
             Analysisedmuscle(createtime: tomorrow, workoutid: -1, muscle: "Back",
                              primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),
             Analysisedmuscle(createtime: tomorrow, workoutid: -1, muscle: "Quadriceps",
                              primaryExerciseCnt: 1, primaryVolume: 1000, secondaryExerciseCnt: 5),

         */
    ]

    try! AppDatabase.shared.saveAnalysisedmuscles(&analysisedlist)
    return analysisedlist
}

func mockanalysisedexercise() -> [Analysisedexercise] {
    try! AppDatabase.shared.deleteAnalysisedexerciselist(workoutid: -1)

    let today = Date()

    let severalDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: today) ?? today
    let yestoday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today

    return []
}

func mockSelfie() -> Selfie {
    let _s = Selfie(nick: "James Bond",
                    phone: "15869120771",
                    gender: .male,
                    weight: 65, weightunit: .kg,
                    height: 170,
                    birthyear: 1990,
                    birthmonth: 2)
    return _s
}
