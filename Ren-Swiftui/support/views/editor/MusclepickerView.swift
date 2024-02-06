//
//  MusclepickerView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/9.
//

import SwiftUI

struct MusclepickerView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            MusclepickerView(selected: .constant("chest"),
                             rangelist: [
                                 "chest",
                                 "back",
                                 "shoulders",
                             ])
        }
    }
}

struct MusclepickerView: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition
    
    @Binding var selected: String
    /*
     * percent range.
     */
    var rangelist: [String]

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                HStack {
                    Picker(selection: self.$selected, label: Text("")) {
                        ForEach(rangelist, id: \.self) { each in
                            LocaleText(each)
                                //.font(.system(size: DEFINE_FONT_SIZE))
                                .tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(
                        width: geometry.size.width ,
                        height: geometry.size.height,
                        alignment: .center
                    )
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            SPACE
            inputab.frame(height: NORMAL_POPUP_HEIGHT)
            SPACE

            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Floatingbutton(label: "confirm",
                               disabled: false,
                               color: preference.theme).padding(.horizontal)
            }
        }
    }
}
