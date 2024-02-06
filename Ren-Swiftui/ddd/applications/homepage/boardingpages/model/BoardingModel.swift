//
//  BoardingModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/17.
//

import Foundation

class BoardingModel: ObservableObject {
    @Published var nick: String = ""
    @Published var phoneNumber: String = ""

    @Published var gender: Gender = .male

    @Published var weight: Int = 60
    @Published var weightunit: Weightunit = .kg

    @Published var height: Int = 175

    @Published var birthyear: Int = 2000
    @Published var birthmonth: Int = 1

    var age: Int {
        let dateComponents = DateComponents(year: birthyear, month: birthmonth)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let components = calendar.dateComponents([.year], from: date, to: Date())

        return components.year ?? 0
    }

    func finish(_ appstate: AppState) -> Themecolor {
        if appstate != .finished {
            return Themecolor.blue
        }

        var selfie = Selfie(
            nick: nick,
            phone: phoneNumber,
            gender: gender,
            weight: weight, weightunit: weightunit,
            height: height,
            birthyear: birthyear,
            birthmonth: birthmonth
        )

        try! AppDatabase.shared.saveSelfie(&selfie)

        if let queried = AppDatabase.shared.querySelfie() {
            log("\(queried)")
        }

        return gender == .male ? .blue : .pink
    }
}
