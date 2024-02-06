//
//  Restimer.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/15.
//

import Combine
import Foundation

public class Restimer: ObservableObject {
    var starttime: Date
    var limittimeinterval: TimeInterval
    var callback: (_ counter: Int) -> Void

    public init(starttime: Date = Date(),
                interval: TimeInterval, callback: @escaping (_ counter: Int) -> Void) {
        self.starttime = starttime
        limittimeinterval = interval
        self.callback = callback
    }

    var ofcompletetime: TimeInterval {
        return TimeInterval(Int(Date().timeIntervalSince(starttime) + 1))
    }
}

/*

 import Combine
 import Foundation

 public class Restimer: ObservableObject {
     public enum Status {
         case stop
         case countdown
     }

     private(set) var formattedduration: String = "00:00"
     public private(set) var limittimeinterval: TimeInterval
     public private(set) var nextfractioncompleted: Double = 0.0

     var formattedlimitduration: String {
         return timeformatter.string(from: limittimeinterval)!
     }

     private var timer: Timer?
     public private(set) var status = Status.stop

     private lazy var timeformatter: DateComponentsFormatter = {
         let formatter = DateComponentsFormatter()
         formatter.unitsStyle = .positional
         formatter.allowedUnits = [.minute, .second]
         formatter.zeroFormattingBehavior = [.pad]
         return formatter
     }()

     private var counter = 0 {
         willSet {
             objectWillChange.send()
         }

         didSet {
             let reverse = limittimeinterval - TimeInterval(integerLiteral: Int64(counter))
             formattedduration = timeformatter.string(from: reverse)!

             switch status {
             case .stop:
                 nextfractioncompleted = 0.0
             case .countdown:
                 nextfractioncompleted = Double(1 + counter) / limittimeinterval
             }
         }
     }

     var callback: (_ counter: Int) -> Void

     public init(interval: TimeInterval, callback: @escaping (_ counter: Int) -> Void) {
         limittimeinterval = interval
         self.callback = callback
     }
 }

 public extension Restimer {
     func start() {
         guard status != .countdown else { return }
         starttimer()
     }

     func stop() {
         let counter = self.counter

         status = .stop

         timer?.invalidate()
         callback(counter)
     }

     func addlimit(_ delta: TimeInterval) {
         self.limittimeinterval += delta
     }
 }

 private extension Restimer {
     func starttimer() {
         status = .countdown
         counter = 0

         timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
             guard let self = self else { return }

             self.counter += 1
             if self.limittimeinterval <= TimeInterval(self.counter) {
                 self.stop()
             }
         }
     }
 }

 */
