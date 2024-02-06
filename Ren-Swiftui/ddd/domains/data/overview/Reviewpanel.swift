//
//  Reviewpanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/7.
//

import SwiftUI

struct Reviewpanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Reviewpanel().frame(height: 280)
            // .border(Color.red)
        }
    }
}

let GRAPH_VIEW_HEIGHT: CGFloat = UIScreen.height * 2 / 5
let GRAPH_VIEW_WIDTH: CGFloat = UIScreen.width - 10

struct Reviewpanel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    @StateObject var model = Reviewpanelmodel()

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                NavigationLazyView(
                    Reviewmusclebetaview(days: model.days)
                        .environmentObject(model)
                )
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            } label: {
                ZStack {
                    musclegraph

                    desc
                }
                .environmentObject(model)
                .onChange(of: trainingmodel.finishedid) { _ in
                    model.refresh()
                }
            }
            .isDetailLink(false)
            .frame(width: UIScreen.width - 20, height: 180)
            .background(preference.theme.opacity(0.1)) // NORMAL_BG_CARD_COLOR
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 15)
        }
    }
}

extension Reviewpanel {
    var desc: some View {
        HStack {
            SPACE.frame(width: 20)

            degreedesc

            SPACE

            VStack(alignment: .trailing) {
                SPACE

                SPACE.frame(height: 50)

                linkbutton

                SPACE.frame(height: 20)

                HStack {
                    SPACE

                    VStack(alignment: .trailing, spacing: 2) {
                        VStack(alignment: .trailing) {
                            Text("\(model.analysiseds.count) \(preference.language("workoutscount", firstletteruppercase: false))")
                        }
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE).italic())
                        .foregroundColor(NORMAL_LIGHT_BUTTON_COLOR)

                        Text("\(preference.languagewithplaceholder("shortlastdays", firstletteruppercase: false, value: "\(model.days)"))")
                            .font(.system(size: DEFINE_FONT_SMALLER_SIZE).weight(.bold))
                            .foregroundColor(NORMAL_LIGHTER_COLOR)
                        // .foregroundColor(preference.theme)
                    }
                }
                .frame(width: 120, height: 50)
                // .border(Color.red)

                SPACE
            }

            SPACE.frame(width: 20)
        }
    }

    var musclegraph: some View {
        VStack {
            SPACE
            HStack(spacing: 0) {
                SPACE.frame(width: 50)

                Reviewbodygraph(pagedto: .frontbody)
                    .frame(width: 100, height: 160)
                Reviewbodygraph(pagedto: .backbody)
                    .frame(width: 100, height: 160)

                SPACE
            }
            SPACE
        }
        .padding()
        .environmentObject(model)
    }

    var degreedesc: some View {
        VStack(spacing: 5) {
            SPACE
            LocaleText("low")
                .foregroundColor(Musclecolor.lighter.color)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2))
                .frame(height: 30)

            ForEach(Musclecolor.allCases, id: \.self) {
                musclecolor in

                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 10, height: 10)
                    .foregroundColor(
                        musclecolor.color
                    )
            }

            LocaleText("high")
                .foregroundColor(Musclecolor.darker.color)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2))
                .frame(height: 30)

            SPACE
        }
        .foregroundColor(Color(.systemGray))
        .font(.system(size: 13))
        .padding(.vertical, 10)
    }
}

extension Reviewpanel {
    var linkbutton: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 20))
            .foregroundColor(preference.theme)
            .contentShape(Rectangle())
    }
}

struct Controlldaysbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Reviewdatamodel

    var body: some View {
        VStack {
            Button {
                model.adddays()
            } label: {
                displaybutton("plus")
            }

            Text("\(model.days) \(preference.language("days"))")
                .font(.system(size: 14, design: .rounded).weight(.heavy))
                .foregroundColor(NORMAL_GRAY_COLOR)
                .padding(.vertical)

            Button {
                model.minusdays()
            } label: {
                displaybutton("minus")
            }
        }
    }

    func displaybutton(_ img: String) -> some View {
        Image(systemName: img)
            .font(.system(size: 18).weight(.bold))
            .frame(width: 40, height: 40)
            .background(
                Circle().foregroundColor(preference.theme.opacity(0.2))
            )
    }
}
