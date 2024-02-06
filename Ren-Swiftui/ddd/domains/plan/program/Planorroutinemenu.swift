//
//  PlanprogramMenu.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/21.
//

import SwiftUI

struct Programorroutinemenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ScrollView(.vertical, showsIndicators: false) {
                Trainingview()
            }
        }
    }
}

let TRAININGVIEW_PLANSORROUTINES_KEY: String = "pagedtrainingview"

struct Programorroutinemenu: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var pagedto: Pagedtoplanorroutine

    var body: some View {
        VStack(spacing: 15) {
            HStack(alignment: .lastTextBaseline, spacing: 20) {
                SPACE

                ForEach(Planorroutine.allCases, id: \.self) {
                    each in

                    Programorroutineicon(menu: each)
                }

                SPACE
            }
            .padding(.horizontal)
        }
    }
}

struct Programorroutineicon: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var pagedto: Pagedtoplanorroutine

    var menu: Planorroutine

    var isfocused: Bool {
        pagedto.pagedto == menu
    }

    var unfocusedcolor: Color = NORMAL_LIGHT_BUTTON_COLOR

    var body: some View {
        label
            .contentShape(Rectangle())
            .onTapGesture {
                pagedto.pagedto = menu

                DispatchQueue(label: "workoutsmenu", qos: .background).async {
                    var appcache = Appcache(
                        cachekey: TRAININGVIEW_PLANSORROUTINES_KEY,
                        cachevalue: menu.rawValue
                    )
                    try! AppDatabase.shared.saveappcache(&appcache)
                }
            }
    }

    var label: some View {
        VStack(spacing: 0) {
            LocaleText(
                menu.rawValue,
                usefirstuppercase: false,
                tracking: 0.3
            )
            .font(.system(size: isfocused ? DEFINE_FONT_BIGGEST_SIZE : DEFINE_FONT_SIZE).weight(.heavy))
            .foregroundColor(isfocused ? NORMAL_LIGHTER_COLOR : unfocusedcolor)
        }
    }
}

/*
 VStack {

     // .frame(width: PORR_FULL_WIDTH)
     /*
      ZStack(alignment: .bottom) {
          LOCAL_DIVIDER

          Rectangle()
              .foregroundColor(preference.theme)
              .frame(width: PORR_WIDTH, height: 1)
              .position(x: 0 + PORR_WIDTH / 2)
              .offset(x: 0 + CGFloat(pagedto.pagedto.index) * PORR_WIDTH, y: 0)
      }
      .frame(width: PORR_WIDTH * 2, height: 1)

      SPACE
      */

 }
 .frame(height: 32)

 */
