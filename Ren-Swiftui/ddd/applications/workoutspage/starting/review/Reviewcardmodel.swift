
import Foundation

class Reviewcardmodel: ObservableObject {
    var exerciseidset = Set<Int64>()

    init() {
        refresh()
    }

    func refresh() {
        let now = Date()
        let start = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
        let interval = DateInterval(start: start, end: now)

        let analysiseds = AppDatabase.shared.querylast20analysisedexercise(interval, limit: 10)
        if analysiseds.isEmpty {
            return
        }

        analysiseds.forEach { self.exerciseidset.insert($0.exerciseid) }
        objectWillChange.send()
    }
}

extension Reviewcardmodel {
    static var shared = Reviewcardmodel()
}
