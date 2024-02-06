//
//  OneexerciseReviewcard.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/12.
//

import SwiftUI

struct OneexerciseReviewcard: View {
    @Environment(\.colorScheme) var colorscheme
    @EnvironmentObject var preference: PreferenceDefinition

    @StateObject var model: OneexerciseReviewcardmodel

    init(_ exerciseidset: Set<Int64>) {
        _model = StateObject(wrappedValue: OneexerciseReviewcardmodel(exerciseidset))
    }

    var body: some View {
        ZStack {
            ZStack {
                NORMAL_BG_VIDEO_COLOR

                exercisevideolayer

                NORMAL_BG_CARD_COLOR.opacity(0.5)

                labelcard
            }
            .onTapGesture {
                withAnimation {
                    model.refresh()
                }
            }

            buttonslayer
        }
        .frame(width: UIScreen.width - 20, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 15)
    }

    var labelcard: some View {
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
        .environmentObject(model)
    }
}

extension OneexerciseReviewcard {
    var ofbgcolor: Color {
        if colorscheme == .dark {
            return NORMAL_BG_COLOR.opacity(0.5)
        } else {
            return NORMAL_GRAY_COLOR.opacity(0.5)
        }
    }

    var exercisevideolayer: some View {
        HStack {
            GeometryReader {
                reader in

                let width = reader.size.width / 2
                let height = reader.size.height / 2

                if let _exercisedef = model.exercise {
                    VideoView(v: _exercisedef.exercise.imgname, rate: 1)
                        .opacity(0.4)
                        .frame(width: width, height: height)
                        .offset(x: width, y: height - 30)
                }
            }
        }
    }
}

extension OneexerciseReviewcard {
    var buttonslayer: some View {
        HStack {
            SPACE

            VStack {
                SPACE

                if let _def = model.exercise {
                    NavigationLink {
                        NavigationLazyView(
                            ExerciseView(exercise: _def, defaultpage: .reviews)
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        )
                    } label: {
                        Image("trending")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(preference.theme)
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(
                                Circle()
                                    .foregroundColor(preference.themesecondarycolor)
                            )
                            .contentShape(Rectangle())
                    }
                    .isDetailLink(false)
                }
            }
        }
        .padding()
    }
}
