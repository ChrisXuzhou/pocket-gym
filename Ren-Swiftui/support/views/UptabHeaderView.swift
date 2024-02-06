//
//  UpTabHeaderView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/18.
//

import SwiftUI

struct UpTabHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            UptabHeaderView(
                present: .constant(true),
                img: Image("icon_2"),
                title: "样本标题",
                subtitle: "样本副标题"
            ) {
                HStack(spacing: 10) {
                    Button {
                    } label: {
                        Image(systemName: "stop.circle.fill")
                            .foregroundColor(.red.opacity(0.8))
                    }

                    Button {
                    } label: {
                        Image(systemName: "gear.circle.fill")
                    }
                }
                .font(.system(size: 25))
                .foregroundColor(.blue.opacity(0.7))
            }
            .padding(.horizontal)
        }
    }
}

let UP_HEADER_TITLE_FONT_SIZE: CGFloat = DEFINE_FONT_SIZE
let UP_HEADER_SUBTITLE_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE

struct UptabHeaderView<BarControlsView>: View where BarControlsView: View {
    init(present: Binding<Bool>,
         showbackbutton: Bool = true,
         presentcolor: Color = NORMAL_LIGHTER_COLOR,
         img: Image? = nil,
         title: String? = nil,
         titlecolor: Color = NORMAL_COLOR,
         subtitle: String? = nil,
         @ViewBuilder barcontrolsView: @escaping () -> BarControlsView) {
        _present = present
        self.showbackbutton = showbackbutton
        self.presentcolor = presentcolor
        self.titlecolor = titlecolor
        self.img = img
        self.title = title
        self.subtitle = subtitle
        self.barcontrolsView = barcontrolsView
    }

    @Binding var present: Bool
    var showbackbutton: Bool = true
    var presentcolor: Color
    var titlecolor: Color

    var backbutton: some View {
        HStack {
            if showbackbutton {
                Button {
                    present = false
                } label: {
                    Backarrow(color: presentcolor)
                }
                .padding(.trailing, 10)
            }
        }
    }

    var img: Image?

    var displayedImg: some View {
        HStack {
            if let _img = img {
                _img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.trailing, 10)
            }
        }
    }

    var title: String?
    var subtitle: String?

    var displayedTitle: some View {
        VStack(alignment: .center) {
            HStack {
                if let _title = title {
                    LocaleText(_title,
                               usefirstuppercase: false,
                               alignment: .center,
                               usescale: false)
                        .foregroundColor(titlecolor)
                        .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                        .padding(0)
                }
            }

            HStack {
                if let _subtitle = subtitle {
                    LocaleText(_subtitle,
                               linelimit: 2, alignment: .center)
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                        .font(.system(size: UP_HEADER_SUBTITLE_FONT_SIZE).bold())
                        .padding(0)
                }
            }
        }
    }

    var barcontrolsView: () -> BarControlsView

    var body: some View {
        HStack(spacing: 0) {
            backbutton

            displayedImg

            displayedTitle

            SPACE

            self.barcontrolsView()
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
    }
}
