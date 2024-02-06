//
//  ConfigandselfieListItem.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/19.
//

import SwiftUI

struct Listitemlabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Listitemlabel(
                    img: Image("preference"),
                    keyortitle: "语言",
                    value: "简体中文"
                ) {
                }

                Listitemlabel(
                    keyortitle: "性别"
                ) {
                    GenderselecterView(selectedgender: .constant(.male))
                }
            }
        }
    }
}

let LIST_ITEM_TITLE_WIDTH: CGFloat = UIScreen.width / 2
let LIST_ITEM_HEIGHT: CGFloat = 55

struct Listitemlabel<ValueView>: View where ValueView: View {
    var img: Image?
    var imgsize: CGFloat
    var sampleview: AnyView?
    var keyortitle: String?
    var value: String?
    var showarrow: Bool
    var valueview: () -> ValueView

    init(img: Image? = nil,
         imgsize: CGFloat = 20,
         sampleview: AnyView? = nil,
         keyortitle: String? = nil,
         value: String? = nil,
         showarrow: Bool = true,
         @ViewBuilder valueview: @escaping () -> ValueView) {
        self.img = img
        self.imgsize = imgsize
        self.sampleview = sampleview
        self.keyortitle = keyortitle
        self.value = value
        self.showarrow = showarrow
        self.valueview = valueview
    }

    var body: some View {
        content
            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .padding(.horizontal)
            .frame(height: LIST_ITEM_HEIGHT)
    }

    var content: some View {
        HStack {
            HStack(spacing: 5) {
                if let _img = img {
                    _img
                        .resizable()
                        .frame(width: imgsize, height: imgsize)
                        .frame(width: 30, height: 30, alignment: .center)
                }

                if let _s = sampleview {
                    _s
                        .frame(width: imgsize, height: imgsize)
                        .frame(width: 30, height: 30, alignment: .center)
                }

                if let _keyortitle = keyortitle {
                    LocaleText(_keyortitle, usefirstuppercase: false, linelimit: 1)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                        .frame(alignment: .leading)
                        .foregroundColor(NORMAL_COLOR)
                }
            }

            SPACE

            HStack( spacing: 5) {
                
                SPACE
                
                if let _value = value {
                    Text(_value)
                        .lineLimit(1)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                        .padding(.leading, 5)
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                        .frame(alignment: .trailing)

                    if showarrow {
                        Image(systemName: "chevron.right")
                            .foregroundColor(NORMAL_GRAY_COLOR)
                    }
                } else {
                    self.valueview()
                }
            }
            .frame(width: 130)
            

        }
    }
}
