//
//  WeighteditorView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/19.
//

import SwiftUI

struct WeighteditorView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            WeighteditorView(weightunit: .constant(.kg), weight: .constant(75))
        }
    }
}

struct WeighteditorView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var presentmode

    @Binding var weightunit: Weightunit
    @Binding var weight: Int

    let weightkgList = [Int](20 ..< 224)
    let weightlbList = [Int](50 ..< 499)

    var relatedweightList: [Int] {
        if weightunit == .kg {
            return weightkgList
        } else {
            return weightlbList
        }
    }

    let weightunitList: [Weightunit] = [.kg, .lb]

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Picker(selection: self.$weight, label: Text("")) {
                        ForEach(relatedweightList, id: \.self) { each in
                            Text("\(each)").tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height, alignment: .center)
                    .compositingGroup()
                    .clipped()

                    Picker(selection: self.$weightunit.onChange({ newvalue in
                        if newvalue == .kg {
                            self.weight = Int(
                                Weight(value: Double(weight), weightunit: .lb).switchuinit().value
                            )
                        }
                        if newvalue == .lb {
                            self.weight = Int(
                                Weight(value: Double(weight), weightunit: .kg).switchuinit().value
                            )
                        }
                    }), label: Text("")) {
                        ForEach(weightunitList, id: \.self) { each in
                            Text("\(each.name)").tag(each)
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

            LocaleText("yourweight")
                .font(.system(size: DEFINE_FONT_SIZE))
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            inputab.frame(height: NORMAL_POPUP_HEIGHT)
            SPACE

            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Floatingbutton(label: "confirm",
                               disabled: false,
                               color: preference.theme)
                    .padding(.horizontal)
            }
        }
    }
}
