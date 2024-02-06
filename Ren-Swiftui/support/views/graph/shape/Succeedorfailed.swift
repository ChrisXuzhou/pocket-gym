//
//  Succeed.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/2.
//

import SwiftUI

struct Succeed_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Succeedorfailed()

                Succeedorfailed(ret: .failed)
            }
        }
    }
}

enum Workoutresult: String {
    case succeeded, failed
}

struct Succeedorfailed: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var ret: Workoutresult = .succeeded
    var description: String?

    var color: Color {
        switch ret {
        case .succeeded:
            return NORMAL_GREEN_COLOR
        case .failed:
            return NORMAL_RED_COLOR
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            color.opacity(0.05).ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(preference.language(ret.rawValue).uppercased())
                        .font(.system(size: DEFINE_FONT_SIZE).weight(.heavy))
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(color, lineWidth: 4)
                )
                .padding(.top)

                if let _description = description {
                    LocaleText(_description)
                        .font(
                            .system(size: DEFINE_FONT_SMALL_SIZE)
                                .weight(.heavy)
                        )
                }
            }
            .foregroundColor(color)
            .rotationEffect(Angle(degrees: -5))
            
        }
    }
}
