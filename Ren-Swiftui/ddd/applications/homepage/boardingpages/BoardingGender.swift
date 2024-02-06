//
//  BoardingNickAndContact.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/15.
//
import SwiftUI

struct BoardingGendert_Previews: PreviewProvider {
    static var previews: some View {
        BoardingGender()
            .environmentObject(BoardingModel())
    }
}

struct BoardingGender: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: BoardingModel

    var body: some View {
        VStack(spacing: 0){
            BoardingQuestion(question: preference.language(LANGUAGE_GENDER))
            GenderselecterView(selectedgender: $model.gender)
        }
    }
}
