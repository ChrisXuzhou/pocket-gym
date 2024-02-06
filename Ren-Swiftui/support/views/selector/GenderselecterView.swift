//
//  GenderSelecterView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/19.
//

import SwiftUI

struct GenderSelecterView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            GenderselecterView(selectedgender: .constant(.other))
        }
    }
}

let GENDER_VIEW_HEIGHT: CGFloat = 70
let GENDER_VIEW_WIDTH: CGFloat = 200

struct Gendercard: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var selectedgender: Gender
    var gender: Gender
    var showtext = false

    var fontsize: CGFloat = 19
    var imgsize: CGFloat = 25
    var fullsize: CGFloat = 40

    var isselected: Bool {
        gender == selectedgender
    }

    var img: String {
        switch gender {
        case .male:
            return "male"
        case .female:
            return "female"
        case .other:
            return "genderless"
        }
    }

    var iconview: some View {
        VStack {
            Image(img)
                .renderingMode(.template)
                .resizable()
                .font(.system(size: fontsize).bold())
                .frame(width: imgsize, height: imgsize)
                .foregroundColor(
                    isselected ? .white : Color(.systemGray2)
                )
                .frame(width: fullsize, height: fullsize)
                .background(
                    Circle().foregroundColor(
                        isselected ?
                            preference.themeprimarycolor : NORMAL_LIGHTEST_GRAY_COLOR
                    )
                )

            if showtext {
                LocaleText(gender.rawValue)
                    .font(.system(size: 13))
                    .foregroundColor(
                        isselected ? preference.theme : Color(.systemGray)
                    )
            }
        }
    }

    var body: some View {
        iconview
            .onTapGesture {
                selectedgender = gender
            }
    }
}

struct GenderselecterView: View {
    @Binding var selectedgender: Gender
    var selectionspacing: CGFloat = 30
    var fontsize: CGFloat = 19
    var imgsize: CGFloat = 25
    var fullsize: CGFloat = 40

    var body: some View {
        HStack(spacing: selectionspacing) {
            Gendercard(
                selectedgender: $selectedgender,
                gender: .male,
                fontsize: fontsize,
                imgsize: imgsize,
                fullsize: fullsize
            )
            Gendercard(
                selectedgender: $selectedgender,
                gender: .female,
                fontsize: fontsize,
                imgsize: imgsize,
                fullsize: fullsize)
            Gendercard(
                selectedgender: $selectedgender,
                gender: .other,
                fontsize: fontsize,
                imgsize: imgsize,
                fullsize: fullsize)
        }
        // .frame(width: GENDER_VIEW_WIDTH, height: GENDER_VIEW_HEIGHT)
    }
}
