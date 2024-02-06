//
//  Languages.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/19.
//
import Foundation

/*
 * logo
 */
let LANGUAGE_APPNAME = "appname"
let LANGUAGE_START = "start"
let LANGUAGE_SKIP = "skip"
let LANGUAGE_NEXT = "next"
let LANGUAGE_CONFIRM = "confirm"

/*
 let LANGUAGE_SAVE = "save"
 let LANGUAGE_CANCEL = "cancel"
 */
let LANGUAGE_SETTINGS = "settings"
let LANGUAGE_PLANS = "plans"
let LANGUAGE_ACTIVITY = "activity"
let LANGUAGE_PLAN = "plan"
let LANGUAGE_EXERCISES = "exercises"
let LANGUAGE_EQUIPMENTS = "equipments"
let LANGUAGE_RECENTLY = "recently"
let LANGUAGE_EMPTY = "empty"

/*
 * config menu
 */
let LANGUAGE_BODYSTATS = "bodystats"
let LANGUAGE_PREFERENCE = "personal"

/*
 * exercise
 */
let LANGUAGE_RESULTSS = "results"
let LANGUAGE_INSTRUCTIONS = "exercise"

let LANGUAGE_1RM = "1rm"
let LANGUAGE_CAPACITY = "volume"
let LANGUAGE_MAXWEIGHT = "maxweight"

let LANGUAGE_EQUIPMENT = "equipment"
let LANGUAGE_MUSCLE_PRIMARY = "primary"
let LANGUAGE_MUSCLE_SECONDARY = "secondary"

/*
 * review
 */
let LANGUAGE_REST = "rest"

/*
 * config
 */
let LANGUAGE_WEIGHTUNIT = "weightunit"
let LANGUAGE_LANGUAGE = "preference"
let LANGUAGE_DARKMODE = "darkmode"
let LANGUAGE_INTERVALRESTSECONDS = "intervalrestseconds"

/*
 * selfie
 */
let LANGUAGE_AGE = "age"
let LANGUAGE_GENDER = "gender"
let LANGUAGE_HEIGHT = "height"
let LANGUAGE_WEIGHT = "weight"

let LANGUAGE_CONTACT_INFORMATION = "contactinformation"
let LANGUAGE_USERNAME = "username"
let LANGUAGE_PHONE = "phone"

/*
 * training
 */
let LANGUAGE_TRAINING_TODAY = "todaysplan"
let LANGUAGE_TRAINING_FROMTEMPLATES = "fromtemplats"
let LANGUAGE_TRAINING_EDIT_TRAININGRECORD = "edittrainingnots"
let LANGUAGE_TRAINING_ADD_EXERCISES = "addexercises"
let LANGUAGE_TRAINING_AS_SUPERSET = "assuperset"
let LANGUAGE_TRAINING_USE_FINISHBUTTON = "usefinishbutton"

/*
 * batch
 */
let LANGUAGE_SUPERGROUP = "superset"
let LANGUAGE_GIANTGROUP = "giantset"

/*
 * trainingpreference
 */
let LANGUAGE_TRAINING_PREFERENCE = "trainingpreference"
let LANGUAGE_TRAINING_PREFERENCE_WEIGHTUNIT = "changeweightunit"

/*
 * program
 */
let LANGUAGE_SCHEME_WHOLEBODY = "wholebodysplit"
let LANGUAGE_SCHEME_UPPERANDLOWER = "upperandlowerbodysplit"
let LANGUAGE_SCHEME_PUSH_PULL_LEGS = "push/pull/legs"
let LANGUAGE_SCHEME_FOURDAY = "fourdaysplit"
let LANGUAGE_SCHEME_FIVEDAY = "fivedaysplit"

extension String {
    func capitalizedfirstletter() -> String {
        return prefix(1).capitalized
    }

    func capitalizingfirstletter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizefirstletter() {
        self = capitalizingfirstletter()
    }
}

struct Languageword: Codable {
    var id: String
    var english: String?
    var simpledchinese: String?

    func oflabel(_ preference: Language) -> String? {
        switch preference {
        case .english:
            return english
        case .simpledchinese:
            return simpledchinese
        }
    }
}

class LanguageDictionary {
    var definedlist: [Languageword] = []
    var wordsdictionary: [String: Languageword] = [:]

    init() {
        reload()
    }

    func of(_ id: String, preference: Language, firstletteruppercase: Bool = true) -> String {
        if let _s = wordsdictionary[id] {
            let ret = (_s.oflabel(preference) ?? "")
            if firstletteruppercase {
                return ret.uppercaseFirstWords
            }
            return ret
        } else {
            return id
        }
    }

    func reload() {
        // 1 multi language load
        definedlist = load("languagesentence.json") ?? []
        wordsdictionary = Dictionary(uniqueKeysWithValues: definedlist.map { ($0.id, $0) })

        // deprated since 2.12
        // 2 exercise multi language load
        for muscle in EXERCISE_MUSCLE_DEFINE {
            for e in EXERCISE_EQUIPMENT_DEFINE {
                let fileName = muscle + "-" + e + ".json"
                let tmp: [Exercisedef] = load(fileName) ?? []

                if tmp.isEmpty {
                    continue
                }

                for each in tmp {
                    let key = _exercisesystemname(each)
                    wordsdictionary[key] =
                        Languageword(id: key, english: each.name!.en, simpledchinese: each.name!.cn)
                }
            }
        }

        // 3. new displayed muscle words
        let newdisplayedmuscles = AppDatabase.shared.queryNewdisplayedmuscles()
        newdisplayedmuscles.forEach { each in
            wordsdictionary[each.ident] =
                Languageword(id: each.ident, english: each.en, simpledchinese: each.cn)
        }

        // 4、new exercise names
        let newexercises = AppDatabase.shared.queryNewexercisedefs()
        newexercises.forEach { def in
            if let _cn = def.cn, let _en = def.en {
                wordsdictionary[def.ident] =
                    Languageword(id: def.ident, english: _en, simpledchinese: _cn)
            }
        }

        // 5、new muscle names
        let newmuscles = AppDatabase.shared.queryNewmuscledefs()
        newmuscles.forEach { def in
            wordsdictionary[def.ident] =
                Languageword(id: def.ident, english: def.en, simpledchinese: def.cn)
        }
    }
}

extension LanguageDictionary {
    static var shared = LanguageDictionary()
}
