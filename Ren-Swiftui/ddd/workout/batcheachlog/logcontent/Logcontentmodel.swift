//
//  Logcontentmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/29.
//

import Foundation

/*
 
 class Logcontentmodel: ObservableObject {
     var batcheachlog: Batcheachlogwrapper

     init(_ beacheachlog: Batcheachlogwrapper) {
         self.batcheachlog = beacheachlog

         let batcheachlog = beacheachlog.batcheachlog

         resttime = batcheachlog.rest?.description ?? "0"
         repeats = batcheachlog.repeats.description
         weight = String(format: "%.1f", batcheachlog.weight)
     }

     @Published var repeats: String
     @Published var weight: String
     @Published var resttime: String

     let lock = NSLock()
 }

 extension Logcontentmodel {
     func repsfinshed() {
         lock.lock()
         defer {
             lock.unlock()
         }
         
         log("reps finished.")
     }

     func weightfinshed() {
         lock.lock()
         defer {
             lock.unlock()
         }
         
         log("weight finished.")
     }

     func resfinshed() {
         lock.lock()
         defer {
             lock.unlock()
         }
     }
 }

 
 */


/*

 let parsed = Int(repeats) ?? 0

 if let _id = batcheachlog.id {
     if var _batcheachlog = AppDatabase.shared.querybatcheachlog(id: _id) {
         _batcheachlog.repeats = parsed
         try! AppDatabase.shared.savebatcheachlog(&_batcheachlog)
     }
 }

 repeatsid += 1

 let parsed = Double(weight) ?? 0.0
 if let _id = batcheachlog.id {
     if var _batcheachlog = AppDatabase.shared.querybatcheachlog(id: _id) {
         _batcheachlog.weight = parsed
         try! AppDatabase.shared.savebatcheachlog(&_batcheachlog)
     }
 }

 weight = String(format: "%.1f", parsed)

 weightid += 1

 let parsed: Int? = Int(resttime)
 if let _id = batcheachlog.id {

     if var _batcheachlog = AppDatabase.shared.querybatcheachlog(id: _id) {
         _batcheachlog.rest = parsed
         try! AppDatabase.shared.savebatcheachlog(&_batcheachlog)
     }
 }

 wrapper.batcheachlog.rest = parsed
 resttime = parsed?.description ?? "0"

 resttimeid += 1
 */
