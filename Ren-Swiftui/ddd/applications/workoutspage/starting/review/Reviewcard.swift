//
//  Reviewcard.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/12.
//

import SwiftUI

struct Reviewcard_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Reviewcard()
        }
    }
}

let NORMAL_UPPER_PANEL_HEIGHT: CGFloat = 280

struct Reviewcard: View {
    @Environment(\.colorScheme) var colorscheme
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var pagedto: Workoutsviewpagedto

    @StateObject var model = Reviewcardmodel.shared

    var body: some View {
        panel
            .padding(.vertical, 10)
            .environmentObject(model)
            .onChange(of: trainingmodel.finishedid) { _ in
                model.refresh()
            }
    }
}

extension Reviewcard {
    var panel: some View {
        VStack(alignment: .leading) {
            if !model.exerciseidset.isEmpty {
                LocaleText("reviews")
                    .font(.system(size: FOLDER_TITLE_FONT, design: .rounded).bold())
                    .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
                    .padding(.leading)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    if !model.exerciseidset.isEmpty {
                        Reviewpanel()

                        // OneexerciseReviewcard(model.exerciseidset)
                    } else {
                        defaultpanel
                    }
                }
                .padding(.leading, 10)
            }
        }
    }

    var defaultpanel: some View {
        VStack(spacing: 15) {
            Image("dumbbell")
                .renderingMode(.template)
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(NORMAL_GRAY_COLOR)
                .opacity(0.6)

            LocaleText("noexerciseyet", alignment: .center)
                .opacity(0.6)

            NavigationLink {
                NavigationLazyView(
                    Guideview()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                )
            } label: {
                HStack {
                    SPACE

                    LocaleText("quickstartguide", alignment: .center)

                    Image(systemName: "chevron.right")

                    SPACE
                }
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).weight(.heavy))
                .foregroundColor(preference.theme)
            }
            .isDetailLink(false)
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1, design: .rounded))
        .frame(width: UIScreen.width - 20, height: 180)
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .background(preference.theme.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 15)
    }
}
