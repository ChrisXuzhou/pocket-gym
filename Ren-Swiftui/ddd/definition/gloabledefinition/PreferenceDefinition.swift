//
//  LanguageDefinition.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/20.
//

import Foundation
import GRDB
import SwiftUI

extension AppDatabase {
    func observeconfig(
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Config]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Config
                    .order(Column("id").desc)
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class PreferenceDefinition: ObservableObject {
    var config: Config?

    init() {
        config = AppDatabase.shared.queryConfig()
        observeconfig()
    }

    var configObservable: DatabaseCancellable?

    private func observeconfig() {
        configObservable = AppDatabase.shared.observeconfig(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] configs in

                if configs.isEmpty {
                    return
                }

                guard let self = self else { return }

                let _newconfig = configs[0]
                if _newconfig != self.config {
                    self.config = _newconfig
                    self.objectWillChange.send()
                }

            })
    }
}

extension PreferenceDefinition {
    var ofdefaultconfig: Config {
        Config._default()
    }

    var oflanguage: Language {
        if let _c = config {
            return _c.preference
        }

        let systemlanguage = NSLocale.preferredLanguages[0]

        return
            systemlanguage.hasPrefix("zh-Hans") ? .simpledchinese : .english
    }

    func language(_ id: String, firstletteruppercase: Bool = true) -> String {
        LanguageDictionary.shared.of(id, preference: oflanguage, firstletteruppercase: firstletteruppercase)
    }

    func languagewithplaceholder(_ id: String, firstletteruppercase: Bool = true, value: String) -> String {
        let raw = LanguageDictionary.shared.of(id, preference: oflanguage, firstletteruppercase: firstletteruppercase)
        return raw.replacingOccurrences(of: "{}", with: value)
    }

    var ofweightunit: Weightunit {
        if let _c = config {
            return _c.weightunit
        }
        return .kg
    }
    
    var ofresttimer: Int {
        if let _c = config {
            return _c.restinterval ?? 60
        }
        return 60
    }

    var theme: Color {
        config?.themecolor.color ?? NORMAL_THEME_COLOR
    }

    var themesecondarycolor: Color {
        theme.opacity(0.3)
    }

    var themeprimarycolor: Color {
        theme.opacity(0.7)
    }

    func displayweight(_ kg: Double) -> String {
        switch ofweightunit {
        case .kg:
            return String(format: "%.1f", kg)
        case .lb:
            return String(format: "%.1f",
                          Weight(value: kg, weightunit: .kg).switchuinit().value)
        }
    }

    func generateaTrainingpreference(_ workoutmodel: Workoutmodel? = nil) -> TrainingpreferenceDefinition {
        TrainingpreferenceDefinition(config ?? ofdefaultconfig, workoutmodel: workoutmodel)
    }

    var ofusesystemappearance: Bool {
        config?.usesystemappearence ?? true
    }

    var ofappearence: Appearence {
        config?.appearence ?? .light
    }

    var ofcontacttype: Contactustype {
        oflanguage == .english ? Contactustype.twitter : .weibo
    }

    var ofcolon: String {
        oflanguage == .simpledchinese ? "：" : ": "
    }

    var ofcomma: String {
        oflanguage == .simpledchinese ? "，" : ", "
    }
}

extension PreferenceDefinition {
    var shouldrest: Bool {
        if let _after = config?.afterrest {
            return _after == .resttimer
        }

        return false
    }
}

extension PreferenceDefinition {
    static var shared = PreferenceDefinition()
}
