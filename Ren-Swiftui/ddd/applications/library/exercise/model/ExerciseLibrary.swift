import Foundation
import GRDB

extension AppDatabase {
    func observeexerciselist(
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([ExercisePersistable]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                ExercisePersistable
                    .order(Column("id"))
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

var EXERCISE_EQUIPMENT_DEFINE = ["dumbbell", "other", "add"]
var EXERCISE_MUSCLE_DEFINE =
    [
        "chest", "abs", "back", "biceps", "glutes", "hamstrings", "quadriceps", "shoulders", "triceps", "lower-back",
        "calves", "trapezius", "abductors", "adductors", "forearms", "neck",
    ]
/*

  class Exerciselibrary {
      /*
       * id : def
       */
      var exerciseid2def: [Int64: Exercisedef]

      /*
       * muscle : [def]
       */
      var primary2deflist: [String: [Exercisedef]]

      /*
       * equipment: [def]
       */
      var equipment2deflist: [String: [Exercisedef]]

      var definedlist: [Exercisedef]

      init() {
          definedlist = []

          exerciseid2def = [:]
          primary2deflist = [:]
          equipment2deflist = [:]

          definedlist = []

          observeuserdefinedlist()
      }

      var observable: DatabaseCancellable?

      private func observeuserdefinedlist() {
          observable = AppDatabase.shared.observeexerciselist(
              onError: { error in fatalError("Unexpected error: \(error)") },
              onChange: { [weak self] persistablelist in

                  self?.definedlist = persistablelist.map({ $0.toexercisedef })

                  self?.refreshidmap()
                  self?.refreshprimarymusclegrouped()

                  self?.refreshEquipment()

                  log("[refresh all  exerciselist ...]")
              })
      }

      func refreshidmap() {
          exerciseid2def = Dictionary(uniqueKeysWithValues: definedlist.map({ ($0.id, $0) }))
      }

      func refreshprimarymusclegrouped() {
          primary2deflist = Dictionary(grouping: definedlist, by: { $0._primarymuscleid })
      }

      func refreshEquipment() {
          equipment2deflist = Dictionary(grouping: definedlist, by: { $0.primaryequipment })
      }
  }
  Exerciselibrary {
     static var shared: Exerciselibrary? = nil
 }

  */

class Exerciselibrary {
    public static func initializelib() {
        try! AppDatabase.shared.deleteexercisesdangerous()

        for muscle in EXERCISE_MUSCLE_DEFINE {
            for e in EXERCISE_EQUIPMENT_DEFINE {
                let fileName = muscle + "-" + e + ".json"
                let tmp: [Exercisedef] = load(fileName) ?? []
                if tmp.isEmpty {
                    continue
                }

                var exerciselist: [ExercisePersistable] = tmp.map({ convertjsondeftopersist($0) })
                try! AppDatabase.shared.saveexercisepersistables(&exerciselist)
            }
        }
    }

    static func convertjsondeftopersist(_ def: Exercisedef) -> ExercisePersistable {
        let primary: String = def.muscle?.primary ?? "cheset"
        let secondarys: String = def.muscle?.secondary.joined(separator: ",") ?? ""
        let equipments = def.equipment.joined(separator: ",").replacingOccurrences(of: " ", with: "").lowercased()

        let _systemname = _exercisesystemname(def)

        return ExercisePersistable(
            id: def.id,
            name: "",
            systemname: _systemname,
            imgname: _systemname,
            primarymuscle: primary,
            secondarymuscles: secondarys,
            equipments: equipments,
            calc: def.calc,
            type: def.type,
            source: .system,
            deleted: def.isdeleted
        )
    }

    public static func ofexercisedictionary() -> Rawexerciselib {
        var exercises: [Exercisedef] = []

        for muscle in EXERCISE_MUSCLE_DEFINE {
            for e in EXERCISE_EQUIPMENT_DEFINE {
                let fileName = muscle + "-" + e + ".json"
                let tmp: [Exercisedef] = load(fileName) ?? []
                if tmp.isEmpty {
                    continue
                }

                exercises.append(contentsOf:
                    tmp.map({
                        var newexercise = $0
                        let _imgname = _exercisesystemname($0)
                        newexercise.imgname = _imgname

                        return newexercise
                    })
                )
            }
        }

        return Rawexerciselib(exercises)
    }
}

func _exercisesystemname(_ def: Exercisedef) -> String {
    def.name?.en.lowercased().replacingOccurrences(of: " ", with: "_") ?? "empty"
}

class Rawexerciselib {
    var exercises: [Exercisedef] = []
    var dictionary: [Int64: Exercisedef] = [:]

    /*
     * variables for function
     */
    var maxexerciseid: Int64 = 0

    init(_ exercises: [Exercisedef]) {
        self.exercises = exercises
        dictionary = Dictionary(uniqueKeysWithValues: exercises.map({ ($0.id!, $0) }))

        exercises.forEach {
            if let _id = $0.id {
                if _id > maxexerciseid {
                    maxexerciseid = _id
                }
            }
        }
    }

    func nextexerciseid() -> Int64 {
        maxexerciseid += 1
        return maxexerciseid
    }
}
