//
//  Permit.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/9.
//

import Foundation
import StoreHelper

let MONTHLY_SUBSCRIPTION = "com.quantumbubble.pocketfit.pro.mly"


class Permit: ObservableObject {
    @Published var initialized: Bool = false

    var purchased: Bool
    var storehelper: StoreHelper?

    init(purchased: Bool = false) {
        self.purchased = purchased

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.initialized = true
        }
    }

    public func setpurchased(_ newvalue: Bool) {
        purchased = newvalue

        if !initialized {
            initialized = true
        }
        objectWillChange.send()
    }

    public func start(_ storehelper: StoreHelper) async {
        self.storehelper = storehelper
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(loop), userInfo: nil, repeats: true)
    }

    var timer: Timer!

    @objc
    func loop() {
        if let _storehelper = storehelper {
            if _storehelper.hasStarted {
                Task.init {
                    await self.checkpurchased()
                }

                timer.invalidate()
            }
        }
    }

    func checkpurchased() async {
        if let _storehelper = storehelper {
            let purchased = (try? await _storehelper.isPurchased(productId: MONTHLY_SUBSCRIPTION)) ?? false
            setpurchased(purchased)
        }
    }

    func permit() -> Bool {
        if purchased {
            return true
        }

        let _now = Date()
        let interval = Calendar.current.dateInterval(of: .month, for: _now) ?? DateInterval(start: _now, duration: 1)
        let count: Int = AppDatabase.shared.countworkout(interval, stats: .finished)

        return count < FREE_WORKOUTS_LIMIT
    }

    /*
     func completeworkouttimes() {
         let _now = Date()
         let interval = Calendar.current.dateInterval(of: .month, for: _now) ?? DateInterval(start: _now, duration: 1)
         finishedworkouts = AppDatabase.shared.countworkout(interval, stats: .finished)
     }

     */
}
