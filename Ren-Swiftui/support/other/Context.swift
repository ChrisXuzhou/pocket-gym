
import Foundation

enum KgOrlbs: String {
    case kg, lbs
}

class Reps {
    var name: String {
        "次"
    }
}

class MainConfig: ObservableObject {
    var reps = Reps()

    func save(_ keyAndValue: inout ConfigKeyAndValue) {
        if var alreadyExisted = AppDatabase.shared.queryKeyAndValue(key: keyAndValue.key) {
            alreadyExisted.value = keyAndValue.value
            try! AppDatabase.shared.saveKeyAndValue(&alreadyExisted)
        } else {
            try! AppDatabase.shared.saveKeyAndValue(&keyAndValue)
        }
    }

    var kgOrlbs: KgOrlbs {
        didSet {
            var value = ConfigKeyAndValue(key: "kgOrlbs", value: kgOrlbs.rawValue)
            save(&value)
        }
    }

    @Published var restSeconds: Int {
        didSet {
            var value = ConfigKeyAndValue(key: "restSeconds", value: String(restSeconds))
            save(&value)
        }
    }

    @Published var intervalRestOn: Bool {
        didSet {
            var value = ConfigKeyAndValue(key: "intervalRestOn", value: String(intervalRestOn))
            save(&value)
        }
    }

    init(kgOrlbs: KgOrlbs, restSeconds: Int, intervalRestOn: Bool) {
        self.kgOrlbs = kgOrlbs
        self.restSeconds = restSeconds
        self.intervalRestOn = intervalRestOn
    }
}

extension MainConfig {
    public static func createMainConfigFromDb() -> MainConfig {
        var kgOrlbs = KgOrlbs.kg

        /*
         * kg or lbs
         */
        if let keyAndVlaue = AppDatabase.shared.queryKeyAndValue(key: "kgOrlbs") {
            if KgOrlbs.lbs.rawValue == keyAndVlaue.value {
                kgOrlbs = KgOrlbs.lbs
            }
        }

        var restSeconds = 0
        /*
         * restSeconds
         */
        if let keyAndVlaue = AppDatabase.shared.queryKeyAndValue(key: "restSeconds") {
            restSeconds = Int(keyAndVlaue.value) ?? 0
        }

        var intervalRestOn = false
        /*
         * intervalRestOn
         */
        if let keyAndVlaue = AppDatabase.shared.queryKeyAndValue(key: "intervalRestOn") {
            if keyAndVlaue.value == "true" {
                intervalRestOn = true
            }
        }

        return MainConfig(kgOrlbs: kgOrlbs, restSeconds: restSeconds, intervalRestOn: intervalRestOn)
    }
}

extension MainConfig {
    public static var shared = createMainConfigFromDb()
}

