import Foundation
import GRDB

class RunningContext: ObservableObject {
    @Published var progressingWorkout: [Workout]
    var progressingTimer: Trainingtimer = Trainingtimer()

    init() {
        progressingWorkout = []
        observeProgressingWorkout()
    }

    var progressingWorkoutObservable: DatabaseCancellable?

    private func observeProgressingWorkout() {
        progressingWorkoutObservable = AppDatabase.shared.observeProgressingWorkout(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] progressing in
                if !(self?.progressingWorkout.isEmpty ?? true) && !progressing.isEmpty {
                    let origin = self?.progressingWorkout[0]
                    let first = progressing[0]
                    if origin?.id == first.id {
                        return
                    }
                }

                self?.progressingWorkout = progressing
                self?.progressingTimer = Trainingtimer()
            })
    }

    @Published var presentingFinishingToast = false
}

extension RunningContext {
    static let shared = RunningContext()
}

extension AppDatabase {
    func observeProgressingWorkout(
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Workout]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Workout.filter(Column("stats") == Stats.progressing.rawValue).fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}
