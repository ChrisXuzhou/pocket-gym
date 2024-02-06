//
//  NewexerciseButton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/19.
//

import SwiftUI

struct Newaexercisebutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Newaexercisebutton(muscleid: "abs")
            }
        }
        .environmentObject(Exerciselabellistmodel([]))
    }
}

enum NewaexercisebuttonType {
    case small, big
}

struct Newaexercisebutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Librarymodel

    @State var shownewaexerciseview = false
    var muscleid: String?

    @State var newaexercise: Bool = false
    var body: some View {
        VStack {
            Button {
                newaexercise = true
            } label: {
                LocaleText("newaexercise", linelimit: 1)
                    .foregroundColor(.white)
                    .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())
                    .frame(width: NEW_A_TEMPLATE_WIDTH, height: NEW_A_TEMPLATE_HEIGHT)
                    .background(
                        NORMAL_LIGHT_GRAY_COLOR
                    )
            }
            /*
             
             .sheet(isPresented: $newaexercise) {
                 Exercisevieweditor(primarymuscleid: muscleid)
                     .navigationBarHidden(true)
                     .navigationBarBackButtonHidden(true)
             }
             
             */
        }
    }
}

/*

 NavigationLink(isActive: $newaexercise) {

 } label: {
 }
 .isDetailLink(false)
 */
