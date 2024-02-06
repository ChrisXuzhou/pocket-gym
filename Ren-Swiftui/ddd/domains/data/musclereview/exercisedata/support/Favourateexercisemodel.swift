//
//  Favourateexercisemodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/9.
//

import Foundation
import GRDB

class Favourateexercisemodel: ObservableObject {
    var markedexerciseidset: Set<Int64>
    var muscleid2markedexerciseidlist: [String: [Int64]]

    init() {
        markedexerciseidset = []
        muscleid2markedexerciseidlist = [:]

        let markedexercises = AppDatabase.shared.queryFocusedexerciseconfigList()
        let exerciseidset = Set<Int64>(markedexercises.map { $0.exerciseid })
        markedexerciseidset = exerciseidset
        muscleid2markedexerciseidlist = [:]
        
        /*
         Dictionary(grouping: Array(exerciseidset), by: { exerciseid in Exerciselibrary.ofexercise(exerciseid)?._primarymuscleid ?? "" })
         */
        
        //observeMarkedexerciselist()
    }

    var markedexerciselistObservable: DatabaseCancellable?

    private func observeMarkedexerciselist() {
        markedexerciselistObservable = AppDatabase.shared.observeMarkedexerciseidlist(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] markedexercises in

                let exerciseidset = Set<Int64>(markedexercises.map { $0.exerciseid })
                self?.markedexerciseidset = exerciseidset
                self?.muscleid2markedexerciseidlist = [:]
                
                // Dictionary(grouping: Array(exerciseidset), by: { Exerciselibrary.ofexercise($0)?._primarymuscleid ?? "" })

                self?.objectWillChange.send()
            })
    }
    
    func exerciseidlist(_ muscleid: String) -> [Int64] {
        (muscleid2markedexerciseidlist[muscleid] ?? []).sorted { l, r in
            l < r
        }
    }
}
