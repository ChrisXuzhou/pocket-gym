//
//  Muscleinitializer.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/4.
//

import Foundation

/*
 ****************************************************************
 * csv and initialize to db
 */

let DISPALYED_MUSCLE_FILE_NAME: String = "new-muscle-display.csv"
let MUSCLE_FILE_NAME: String = "new-muscle.csv"
let EXERCISE_FILE_RAW_NAME: String = "new-exercise-raw.csv"
let EXERCISE_FILE_NAME: String = "new-exercise.csv"

class Libraryinitializer {
    let lock = NSLock()

    func initialize() {
        lock.lock()
        defer {
            lock.unlock()
        }

        initializenewmuscles()
        initializedisplayedmuscles()
        initializenewexercises()
    }
}

extension Libraryinitializer {
    static var shared = Libraryinitializer()
}

extension Libraryinitializer {
    private func initializenewmuscles() {
        let all = AppDatabase.shared.queryNewmuscledefs()
        if !all.isEmpty {
            return
        }

        let rows: [[String]] = loadcsv(MUSCLE_FILE_NAME)

        if rows.isEmpty {
            return
        }

        var newmuscles: [Newmuscledef] = []

        for row: [String] in rows {
            let id = row[0].decrypted
            let en = row[1].decrypted
            let cn = row[2].decrypted
            let displayedid = row[3].decrypted

            let muscledef = Newmuscledef(ident: id, cn: cn, en: en, displayedid: displayedid)

            newmuscles.append(muscledef)
        }

        try! AppDatabase.shared.saveNewmuscles(&newmuscles)
    }

    private func initializedisplayedmuscles() {
        let hadmuscles = AppDatabase.shared.queryNewdisplayedmuscles()
        if !hadmuscles.isEmpty {
            return
        }

        let rows: [[String]] = loadcsv(DISPALYED_MUSCLE_FILE_NAME)

        if rows.isEmpty {
            return
        }

        var groupedmuscles: [Newdisplayedmuscle] = []

        for row: [String] in rows {
            let id = row[0].decrypted
            let level = Musclelevel(rawValue: row[1].decrypted)!
            let groupid = row[2].decrypted.isEmpty ? nil : row[2].decrypted
            let en = row[3].decrypted
            let cn = row[4].decrypted

            let muscledef = Newdisplayedmuscle(ident: id, level: level, en: en, cn: cn, groupid: groupid)

            groupedmuscles.append(muscledef)
        }

        try! AppDatabase.shared.saveNewdisplayedmuscles(&groupedmuscles)
    }
}

extension Libraryinitializer {
    func initializenewexercises() {
        let had = AppDatabase.shared.queryNewexercisedefs()
        if !had.isEmpty {
            return
        }

        let rows: [[String]] = loadcsv(EXERCISE_FILE_NAME)

        if rows.isEmpty {
            return
        }

        var exercises: [Newexercisedef] = []

        /*
         [
             "ident",
             "exerciseid",
             "key",
             "imgname",
             "muscleid",
             "displayedprimaryid",
             "displayedsecondaryids",
             "equipmentidx",
             "equipmentids",
             "weighttype", "source", "logtype",
             "cn", "en",
         ]
         */
        for row: [String] in rows {
            exercises.append(
                Newexercisedef(
                    ident: row[0].decrypted,
                    exerciseid: Int64(row[1].decrypted),
                    key: row[2].decrypted,
                    imgname: row[3].decrypted,
                    muscleid: row[4].decrypted, displayedprimaryid: row[5].decrypted,
                    displayedgroupid: row[14].decrypted,
                    displayedsecondaryids: row[6].decrypted,
                    equipmentidx: row[7].decrypted, equipmentids: row[8].decrypted,
                    weighttype: Caculateweight(rawValue: row[9].decrypted) ?? .single,
                    source: .system,
                    logtype: Logtype(rawValue: row[11].decrypted) ?? .repsandweight,
                    cn: row[12].decrypted, en: row[13].decrypted
                )
            )
        }

        try! AppDatabase.shared.saveNewexercisedefs(&exercises)
    }
}

/*
 * raw define converted to exercises define
 */
extension Libraryinitializer {
    func _initializenewexercises() {
        /*
         let had = AppDatabase.shared.queryNewexercisedefs()
         if !had.isEmpty {
             return
         }
         */

        let rows: [[String]] = loadcsv(EXERCISE_FILE_RAW_NAME)

        if rows.isEmpty {
            return
        }

        let rawlib = Exerciselibrary.ofexercisedictionary()

        var exercises: [Newexercisedef] = []

        /*
         * key and its chinese name
         */
        var keymaps: [String: Languageword] = [:]

        for row: [String] in rows {
            // 3
            let key: String = row[0]
            var exercisid: Int64? = Int64(row[1])

            let equipen: String = row[2]
            let equipcn: String = row[3]

            let patternen: String = row[4]
            let patterncn: String = row[5]

            let posen: String = row[6]
            let poscn: String = row[7]

            let actionen: String = row[8]
            let actioncn: String = row[9]

            let muscleid: String = row[10]
            let equipid: String = row[12]

            // 1
            let names = [equipen, patternen, posen, actionen]
                .filter({ !$0.isEmpty })
                .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })

            let ident: String = names
                .map({ $0.replacingOccurrences(of: " ", with: "_").lowercased() })
                .joined(separator: "_")

            let en: String = names.joined(separator: " ")
            let cn: String = [equipcn, patterncn, poscn, actioncn]
                .map({ $0.trimmingCharacters(in: .whitespaces) })
                .filter({ !$0.isEmpty })
                .joined()

            // 2
            if exercisid == nil {
                exercisid = rawlib.nextexerciseid()
            }

            // 4 & 6
            var imgname = ident
            var displayedsecondaryids: String = ""

            var equipmentids: String = ""
            var logtype = Logtype.repsandweight

            if let _raw = rawlib.dictionary[exercisid!] {
                if !_raw._vName.isEmpty {
                    imgname = _raw._vName
                }
                displayedsecondaryids = _raw._secondarymuscleids.map({ $0.uppercaseFirstWords }).joined(separator: "/")

                equipmentids = _raw.equipment
                    .map({
                        let _e = $0.lowercased()
                        if _e == "dumbbells" {
                            return "dumbbell"

                        } else {
                            return _e
                        }
                    })
                    .joined(separator: "/")

                logtype = _raw.logtype
            }

            // 5
            let displayedprimaryid = Musclelibrary.shared.dictionary[muscleid]!.displayedid
            var displayedgroupid = displayedprimaryid

            let shared = Librarynewdisplayedmuscle.shared
            if let _wrapper: Newdisplayedmusclewrapper = shared.dictionary[displayedprimaryid] {
                if let _father = _wrapper.father {
                    displayedgroupid = _father.muscle.ident
                }
            }

            if equipid == "bodyweight" {
                logtype = .reps
            }

            let weighttype = equipid == "dumbbell" ? Caculateweight.double : Caculateweight.single
            let source = Source.system

            exercises.append(
                Newexercisedef(
                    ident: ident,
                    exerciseid: exercisid,
                    key: key,
                    imgname: imgname,
                    muscleid: muscleid,
                    displayedprimaryid: displayedprimaryid, displayedgroupid: displayedgroupid,
                    displayedsecondaryids: displayedsecondaryids,
                    equipmentidx: equipid, equipmentids: equipmentids,
                    weighttype: weighttype, source: source,
                    logtype: logtype,
                    cn: cn, en: en
                )
            )

            keymaps[key] = Languageword(id: key, english: key, simpledchinese: actioncn)
        }

        log(
            [
                "ident",
                "exerciseid",
                "key",
                "imgname",
                "muscleid",
                "displayedprimaryid",
                "displayedsecondaryids",
                "equipmentidx",
                "equipmentids",
                "weighttype", "source", "logtype",
                "cn", "en",
                "displayedgroupid",
            ]
            .joined(separator: ",")
        )

        exercises.forEach { def in
            let _content: [String] =
                [
                    def.ident,
                    "\(def.exerciseid!)",
                    def.key,
                    def.imgname,
                    def.muscleid, def.displayedprimaryid, def.displayedsecondaryids,
                    def.equipmentidx,
                    def.equipmentids,
                    def.weighttype.rawValue, def.source.rawValue, def.logtype.rawValue,
                    def.cn ?? "", def.en ?? "",
                    def.displayedgroupid,
                ]

            log(_content.joined(separator: ","))
        }

        log("\n\n\n\n")

        let encodedData = try! JSONEncoder().encode(Array(keymaps.values))
        let json: String = String(data: encodedData,
                                  encoding: .utf8) ?? "{}"

        log(json)
    }
}

/*
 let DISPALYED_MUSCLE_FILE_NAME: String = "new-muscle-display.csv"
 let MUSCLE_FILE_NAME: String = "new-muscle.csv"
 let EXERCISE_FILE_RAW_NAME: String = "new-exercise-raw.csv"
 let EXERCISE_FILE_NAME: String = "new-exercise.csv"
 */
extension Libraryinitializer {
    func _encryptmuscledef() {
        let rows: [[String]] = loadcsv(MUSCLE_FILE_NAME)
        if rows.isEmpty {
            return
        }

        log(
            [
                "id",
                "en",
                "cn",
                "muscle",
            ]
            .joined(separator: ",")
        )

        for row: [String] in rows {
            // 4
            var rets: [String] = []
            for i in 0 ..< 4 {
                rets.append(row[i].encrypted)
            }

            log(rets.joined(separator: ","))
        }
    }

    func _encryptdisplaymuscledef() {
        let rows: [[String]] = loadcsv(DISPALYED_MUSCLE_FILE_NAME)
        if rows.isEmpty {
            return
        }

        log(
            [
                "id",
                "level",
                "group",
                "en",
                "cn",
            ]
            .joined(separator: ",")
        )

        for row: [String] in rows {
            // 4
            var rets: [String] = []
            for i in 0 ..< 5 {
                rets.append(row[i].encrypted)
            }

            log(rets.joined(separator: ","))
        }
    }

    func _encryptexercisesdef() {
        let rows: [[String]] = loadcsv(EXERCISE_FILE_NAME)
        if rows.isEmpty {
            return
        }

        log(
            [
                "ident",
                "exerciseid",
                "key",
                "imgname",
                "muscleid",
                "displayedprimaryid",
                "displayedsecondaryids",
                "equipmentidx",
                "equipmentids",
                "weighttype", "source", "logtype",
                "cn", "en",
                "displayedgroupid",
            ]
            .joined(separator: ",")
        )

        for row: [String] in rows {
            // 4
            var rets: [String] = []
            for i in 0 ..< 15 {
                rets.append(row[i].encrypted)
            }

            log(rets.joined(separator: ","))
        }
    }
}

public extension String {
    var encrypted: String {
        return AES.shared?.encrypt(string: self) ?? self
    }

    var decrypted: String {
        return AES.shared?.decrypt(string: self) ?? self
    }
}
