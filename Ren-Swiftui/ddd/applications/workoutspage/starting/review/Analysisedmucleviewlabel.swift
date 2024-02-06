//
//  Analysisedmucleviewlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/12.
//

import SwiftUI

struct Analysisedmucleviewlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    //@ObservedObject var model: Analysisedmucleviewlabelmodel
    @StateObject var model: Analysisedmucleviewlabelmodel

    init(_ analysiedmuscle: Analysisedmuscle) {
        /*
         model = Analysisedmucleviewlabelmodel(analysiedmuscle)
        */
        let _wrapped = Analysisedmucleviewlabelmodel(analysiedmuscle)
        _model = StateObject(wrappedValue: _wrapped)
    }

    var label: some View {
        Reviewcardcontent(
            left: model.left,
            right: model.right,
            weightunit: model.ofunit,
            title: model.title,
            description: model.description,
            lefttime: model.leftdate, righttime: model.rightdate,
            vname: nil,
            isint: model.isinit
        )
    }

    var body: some View {
        VStack {
            label
                .padding(10)
        }
    }
}
