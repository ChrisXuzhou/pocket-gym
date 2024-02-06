//
//  Cleaner.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/2.
//

import Foundation

func dangerouscleanalldata() {
    
    try! AppDatabase.shared.deleteprograms()
    try! AppDatabase.shared.deleteprogrameachs()
    
    try! AppDatabase.shared.deleteplans()
    try! AppDatabase.shared.deleteplantasks()
    
    try! AppDatabase.shared.deleteworkouts()
    try! AppDatabase.shared.deletebatchs()
    try! AppDatabase.shared.deletebatchexercisedefs()
    try! AppDatabase.shared.deletebatcheachlogs()
    
}

