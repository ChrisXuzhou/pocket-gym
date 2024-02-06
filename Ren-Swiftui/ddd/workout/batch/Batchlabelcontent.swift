//
//  Batchlabelview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/5.
//

import SwiftUI

struct Batchlabelview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

struct Batchlabelcontent: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition

    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var workoutmodel: Workoutmodel
    @EnvironmentObject var batchmodel: Batchmodel

    @State var showclosingconfirmdialog: Bool = false

    var body: some View {
        ZStack {
            batchslabel
        }
        .onTapGesture {
            self.endtextediting()
        }
        .confirmationDialog(
            Text(preference.language("completetraining") + "?"),
            isPresented: $showclosingconfirmdialog,
            titleVisibility: .visible
        ) {
            Button {
                trainingmodel.stop()
            } label: {
                LocaleText("ok")
            }
        }
    }
}

extension Batchlabelcontent {
    var batchslabel: some View {
        VStack {
            HStack(spacing: 0) {
                SPACE.frame(width: BATCH_EACHLOG_NUMBER_WIDTH)

                SPACE

                Logcontentheader(weightunit: trainingpreference.weightunit)

                SPACE

                SPACE.frame(width: LOG_FINSH_WIDTH)
            }
            .padding(.leading, 10)

            LazyVStack(spacing: 0) {
                if let _maxnumber = batchmodel.numberdictionary.keys.max() {
                    ForEach(0 ... _maxnumber, id: \.self) {
                        num in

                        let batcheachlogs = batchmodel.numberdictionary[num] ?? []

                        Batcheachloggroup(
                            num: num,
                            orderedbatcheachloglist: batcheachlogs
                        )
                        .id(num)
                        .background(
                            num.color
                        )
                    }
                }
            }
            
        }
    }
    
}

/*
 
 List {
     if let _maxnumber = batchmodel.numberdictionary.keys.max() {
         ForEach(0 ... _maxnumber, id: \.self) {
             num in

             let batcheachlogs = batchmodel.numberdictionary[num] ?? []

             Batcheachloggroup(
                 num: num,
                 orderedbatcheachloglist: batcheachlogs
             )
             .id(num)
             .listRowInsets(.init(top: 5, leading: 0, bottom: 0, trailing: 0))
             .listRowSeparator(.hidden)
             .listRowBackground(NORMAL_BG_COLOR)
         }
     }
 }
 .background(NORMAL_BG_COLOR)
 .listStyle(.plain)
 .buttonStyle(BorderlessButtonStyle())
 
 
 LazyVStack {
     if let _maxnumber = batchmodel.numberdictionary.keys.max() {
         ForEach(0 ... _maxnumber, id: \.self) {
             num in

             let batcheachlogs = batchmodel.numberdictionary[num] ?? []

             Batcheachloggroup(
                 num: num,
                 orderedbatcheachloglist: batcheachlogs
             )
             .id(num)
         }
     }
 }
 
 */
