//
//  Fitnessdaysperweekeditor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/11.
//

import SwiftUI

struct Fitnessdaysperweekeditor_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Fitnessdaysperweekeditor(selected: .constant(.lessthan3days))
        }
    }
}

struct Fitnessdaysperweekeditor: View {
    @Binding var selected: Daysrange

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                SPACE

                HStack {
                    Picker(selection: self.$selected, label: Text("")) {
                        ForEach(Daysrange.allCases, id: \.self) { each in
                            LocaleText(each.rawValue)
                                .tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(
                        width: geometry.size.width / 2,
                        height: geometry.size.height,
                        alignment: .center
                    )
                }

                SPACE
            }
        }
    }

    var body: some View {
        PopuptabView {
            inputab.frame(height: NORMAL_POPUP_HEIGHT)
        }
    }
}
