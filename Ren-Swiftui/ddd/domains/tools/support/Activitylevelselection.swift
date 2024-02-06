//
//  Activitylevelselection.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/22.
//

import SwiftUI

struct Activitylevelselection_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Activitylevelselection(selected: .constant(.activityl0))
        }
    }
}

struct Activitylevelselection: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var selected: Activitylevel

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                SPACE

                HStack {
                    Picker(selection: self.$selected, label: Text("")) {
                        ForEach(Activitylevel.allCases, id: \.self) {
                            each in
                            Text("\(preference.language(each.rawValue))")
                                .font(.system(size: DEFINE_FONT_SIZE))
                                .tag(each.rawValue)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(
                        width: geometry.size.width,
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
