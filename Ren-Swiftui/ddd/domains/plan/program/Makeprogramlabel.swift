//
//  Makeprogramlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/28.
//

import SwiftUI

struct Makeprogramlabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Makeprogramlabel()
        }
    }
}

struct Makeprogramlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var model = CustomizeModel()

    var descriptionview: some View {
        VStack(spacing: 15) {
            LocaleText("customizeyourplan")
                .font(.system(size: DEFINE_FONT_SIZE).bold())

            LocaleText("thebestworkoutplanisapersonalizedone")
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1))
                .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.6))
        }
    }

    var nextbutton: some View {
        NavigationLink(isActive: $model.present) {
            NavigationLazyView(
                CustomizeplanView(present: $model.present)
                    .environmentObject(model)
                    .environmentObject(preference)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            )

        } label: {
            Floatingbutton(
                label: preference.language("continue"),
                color: preference.theme
            ).padding(.horizontal)
        }
        .isDetailLink(false)
    }

    var body: some View {
        VStack {
            //  Exercisevideo()

            SPACE

            descriptionview.padding(.vertical)

            nextbutton
        }
        .frame(height: 150)
        .fullScreenCover(isPresented: $model.presentprogram) {
            VStack {
                if let created = model.createdprogram {
                    Programview(
                        program: created,
                        editing: true
                    )
                } else {
                    ProgressView()
                        .onAppear {
                            model.newaprogram()
                        }
                }
            }
        }
    }
}
