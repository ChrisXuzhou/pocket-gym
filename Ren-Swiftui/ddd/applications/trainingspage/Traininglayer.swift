//
//  Traininglayer.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/2.
//


import SwiftUI

struct Traininglayer_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

let TRAINING_LABEL_HEIGHT: CGFloat = 100

class Traininguseroutinesswitch: ObservableObject {
    @Published var value: Bool = false
}

struct Traininglayer: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    var body: some View {
        ZStack {
            training

            result
        }
    }
}

extension Traininglayer {
    /*
     * display training's result.
     */
    var result: some View {
        VStack {
            if trainingmodel.presentresultoverview {
                if let _finishedid = trainingmodel.finishedid {
                    Workoutfinishedlabel(present: $trainingmodel.presentresultoverview, workoutid: _finishedid)
                }
            }
        }
    }

    /*
     * display training layer
     */
    var training: some View {
        ZStack {
            if let model: Workoutmodel = trainingmodel.current {
                if let timer = trainingmodel.trainingtimer {
                    if let trainingpreference = trainingmodel.trainingpreference {
                        ZStack {
                            let restmodel: Workoutrestmodel = trainingmodel.trainingrest ?? Workoutrestmodel()

                            Color.clear
                                .fullScreenCover(
                                    isPresented: $trainingmodel.presentworkoutview) {
                                        NavigationView {
                                            Workoutfacadeview(present: $trainingmodel.presentworkoutview)
                                                .environmentObject(trainingmodel)
                                                .environmentObject(preference)
                                                .environmentObject(trainingpreference)
                                                .environmentObject(model)
                                                .environmentObject(timer)
                                                .environmentObject(restmodel)
                                                .navigationBarHidden(true)
                                                .navigationBarBackButtonHidden(true)
                                        }
                                }
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct Workoutdescription: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var model: Workoutmodel
    @EnvironmentObject var timer: Trainingtimer

    var body: some View {
        HStack(spacing: 0) {
            SPACE

            VStack(spacing: 2) {
                SPACE

                Trainingtimerlabel(
                    trainingtimer: timer,
                    fontsize: DEFINE_FONT_BIGGEST_SIZE,
                    leading: false
                )
                .frame(width: 180, height: 25)

                SPACE
            }

            SPACE
        }
        .padding(.horizontal)
    }
}

/*
 .alert(isPresented: $trainingmodel.presentalertview) {
     Alert(
         title:
         Text(
             preference.language(
                 "remind",
                 firstletteruppercase: false
             )
         ),
         message:
         Text(
             preference.language(
                 "pleasecompletecurrenttraining",
                 firstletteruppercase: false
             )
         ),
         dismissButton: .default(Text(preference.language("ok")))
     )
 }
 */

/*

 struct Trainingbutton: View {
     @EnvironmentObject var preference: PreferenceDefinition
     var img: Image
     var imgsize: CGFloat = 20
     var imgcolor: Color = .white

     var color: Color?
     var paddingsize: CGFloat = 15

     var body: some View {
         img
             .renderingMode(.template)
             .resizable()
             .aspectRatio(contentMode: .fit)
             .frame(width: imgsize, height: imgsize, alignment: .center)
             .foregroundColor(imgcolor)
             .frame(width: 55, height: 55, alignment: .center)
             .background(
                 Circle()
                     .foregroundColor(color ?? preference.theme)
                     .shadow(color: NORMAL_BG_CARD_COLOR, radius: 6, x: 0, y: 1)
             )
     }
 }
 */
