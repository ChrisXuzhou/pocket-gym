//
//  Routermodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/17.
//
import SwiftUI

class Routermodel: ObservableObject {
    @Published var appidentity: AppIdentity?

    init() {
        appidentity = AppDatabase.shared.queryAppIdentity()
    }
}

extension Routermodel {
    func finishedboarding(_ appstate: AppState, themecolor: Themecolor = .blue) {
        /*
         * 1、prepare
         */

        try! AppDatabase.shared.deleteNewmuscledefs()
        try! AppDatabase.shared.deleteNewdisplayedmuscles()
        try! AppDatabase.shared.deleteNewexercisedefs()

        Libraryinitializer.shared.initialize()

        Workout.initroutines()
        Program.initroutines()

        /*
         * 2、finished default config saving.
         */
        var defaultConfig = Config._default()

        defaultConfig.themecolor = themecolor
        defaultConfig.appearence = .light
        try! AppDatabase.shared.saveConfig(&defaultConfig)

        /*
         * 3、finished appidentity saving.
         */
        var identity = AppIdentity(appstate: appstate)
        try! AppDatabase.shared.saveAppIdentity(&identity)

        /*
         * 4、reload resources
         * multi-language
         * exercise-resources
         */
        LanguageDictionary.shared.reload()
        Libraryexercisemodel.shared.reload()

        self.appidentity = identity
        objectWillChange.send()
    }
}

extension Routermodel {
    static var shared = Routermodel()
}

fileprivate extension ColorScheme {
    var appearence: Appearence {
        self == .light ? .light : .dark
    }
}
