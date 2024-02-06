//
//  Trainingtimer.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import Foundation

public enum Timerstate: String {
    case running, paused, stoped
}

public class Trainingtimer: ObservableObject {
    @Published var state: Timerstate = .stoped
    var starttime: Date?
    var stoptime: Date?

    func start(_ starttime: Date = Date()) {
        self.starttime = starttime
        state = .running
    }

    func stop() {
        stoptime = Date()
        state = .stoped
    }

    var isrunning: Bool {
        state == .running
    }
}

/*

 public class Trainingtimer: ObservableObject {
     var timer: Timer?
     var state = Timerstate.stoped
     var hoursminutesseconds: (Int, Int, Int) = (0, 0, 0)

     var counter: TimeInterval = 0.0 {
         willSet {
             objectWillChange.send()
         }
         didSet {
             hoursminutesseconds = secondstohoursminutesseconds(Int(counter))
         }
     }

     var backgroundAt = Date()

     init(_ counter: TimeInterval = 0.0) {
         self.counter = counter
         hoursminutesseconds = secondstohoursminutesseconds(Int(counter))
     }

     let lock = NSLock()

     func starttimer() {
         lock.lock()
         defer {
             lock.unlock()
         }

         state = .running

         if !(timer?.isValid ?? false) {
             timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                 guard let self = self else { return }

                 log("print timer ...\(Date())")
                 self.counter += 1
             }
         }
     }
 }

 extension Trainingtimer {
     var seconds: Int {
         Int(counter)
     }

     var started: Bool {
         state == .running || state == .paused
     }

     var isrunning: Bool {
         state == .running
     }
 }

 extension Trainingtimer {
     func start() {
         if state == .running {
             return
         }

         starttimer()
     }

     func pause() {
         state = .paused
         timer?.invalidate()
     }

     func stop() {
         counter = 0
         state = .stoped
         timer?.invalidate()
     }
 }

 */
