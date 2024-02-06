//
//  Config.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/20.
//

import Foundation
import GRDB

enum Language: String, Codable {
    case english, simpledchinese

    var name: String {
        switch self {
        case .english:
            return "English"
        case .simpledchinese:
            return "简体中文"
        }
    }

    var locale: Locale {
        switch self {
        case .english:
            return Locale(identifier: "en")
        case .simpledchinese:
            return Locale(identifier: "zh-Hans")
        }
    }
}

enum Appearence: String, Codable {
    case dark, light
}

enum Finishmode: String, Codable {
    case none, checkbutton
}

enum Afterrest: String, Codable {
    case none, resttimer
}

public struct Config: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var preference: Language
    var appearence: Appearence
    var themecolor: Themecolor
    var weightunit: Weightunit

    var afterrest: Afterrest? = .resttimer
    var intervalrestinsecs: Int = 60
    var usesystemappearence: Bool? = true

    var finishmode: Finishmode
    
    var useresttimer: Bool? = true
    var restinterval: Int? = 60
    var notifysoundeffect: String? = "default"
    
}

extension Config {
    static func _default() -> Config {
        let preference = fetchdevicelanguage()
        return Config(preference: preference, appearence: .light, themecolor: .blue, weightunit: .kg, finishmode: .checkbutton)
    }
}

extension Config: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveConfig(_ config: inout Config) throws {
        try dbWriter.write { db in
            try config.save(db)
        }
    }

    func queryConfig() -> Config? {
        let config: Config? = try! dbWriter.read { db in
            try Config
                .order(Column("id").desc)
                .limit(1)
                .fetchOne(db)
        }
        return config
    }

    func deleteConfig() throws {
        try dbWriter.write { db in
            _ = try Config.deleteAll(db)
        }
    }
}

extension Config {
    var shouldrest: Bool {
        if let _after = afterrest {
            return _after == .resttimer
        }
        return true
    }
    
    func ofusesystemappearence() -> Bool {
        return usesystemappearence ?? true
    }
}
