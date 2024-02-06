//
//  SampleDatePicker.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/17.
//

import SwiftUI

struct SampleDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                SPACE

                AgeeditorView(birthyear: .constant(1990), birthmonth: .constant(2))
                    .environmentObject(BoardingModel())
                SPACE
            }
            .background(
                NORMAL_BG_COLOR
            )
        }
    }
}

struct PopuptabView<PopupContent>: View where PopupContent: View {
    let content: () -> PopupContent

    init(@ViewBuilder content: @escaping () -> PopupContent) {
        self.content = content
    }

    var body: some View {
        ZStack {
            self.content().zIndex(999)
        }
        .background(
            Rectangle()
                .foregroundColor(NORMAL_BG_CARD_COLOR)
                .cornerRadius(15, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
        )
    }
}

struct AgeeditorView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var presentmode

    @Binding var birthyear: Int
    @Binding var birthmonth: Int

    let monthList = [Int](1 ... 12)
    var yearList = [Int](1900 ... Date().year)

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Picker(selection: self.$birthyear, label: Text("")) {
                        ForEach(yearList, id: \.self) { each in

                            HStack(alignment: .lastTextBaseline, spacing: 1) {
                                Text(each.description)
                                    .font(.system(size: 23))
                            }
                            .tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height, alignment: .center)
                    .compositingGroup()
                    .clipped()

                    Picker(selection: self.$birthmonth, label: Text("")) {
                        ForEach(monthList, id: \.self) { each in
                            HStack(alignment: .lastTextBaseline, spacing: 1) {
                                LocaleText("\(each)month")
                                    .font(.system(size: 23))
                            }
                            .tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height, alignment: .center)
                    .compositingGroup()
                    .clipped()
                }
            }
        }
    }

    var body: some View {
        VStack {
            SPACE

            LocaleText("yourbirthyearandmonth")
                .font(.system(size: DEFINE_FONT_SIZE))
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            inputab.frame(height: NORMAL_POPUP_HEIGHT)

            SPACE

            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Floatingbutton(
                    label: "confirm",
                    disabled: false,
                    color: preference.theme
                )
                .padding(.horizontal)
            }
        }
    }
}
