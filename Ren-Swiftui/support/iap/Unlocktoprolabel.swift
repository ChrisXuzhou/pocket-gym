//
//  Unlocktoprolabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/7.
//

import StoreHelper
import SwiftUI

struct Unlocktoprolabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Unlocktoprolabel()
                    .environmentObject(Permit())

                Unlocktoprolink()
                    .environmentObject(Permit(purchased: true))
            }
        }
    }
}

struct Unlocktoprolink: View {
    @EnvironmentObject var permit: Permit
    @EnvironmentObject var preference: PreferenceDefinition

    @State var showdetail = false

    var labelview: some View {
        VStack(spacing: 2) {
            HStack(spacing: 0) {
                SPACE

                if !permit.purchased {
                    LocaleText("unlockpro", usefirstuppercase: false)
                        .font(
                            .system(size: DEFINE_FONT_SMALLER_SIZE)
                                .weight(.heavy)
                        )
                } else {
                    LocaleText("pro")
                        .font(
                            .system(size: DEFINE_FONT_SMALL_SIZE)
                                .weight(.heavy)
                        )
                }
            }
        }
        .foregroundColor(NORMAL_GOLD_COLOR)
        .contentShape(Rectangle())
    }

    var body: some View {
        Button {
            showdetail = true
        } label: {
            labelview
        }.fullScreenCover(isPresented: $showdetail) {
            PromembershipView(purchaseState: permit.purchased ? .purchased : .unknown,
                              productid: MONTHLY_SUBSCRIPTION)
        }
    }
}

struct Unlocktoprolabel: View {
    @EnvironmentObject var permit: Permit
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var trainingmodel: Trainingmodel

    var imgsize: CGFloat = 35

    var imglayer: some View {
        VStack {
            SPACE
            HStack {
                SPACE
                Image("exercise")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imgsize, height: imgsize, alignment: .center)
                    .padding(10)
            }
        }
    }

    var textlayer: some View {
        VStack(alignment: .leading, spacing: 5) {
            if permit.purchased {
                HStack {
                    Image("member")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imgsize, height: imgsize, alignment: .center)

                    LocaleText("appname")

                    LocaleText("pro")
                }
                .foregroundColor(NORMAL_GOLD_COLOR)
                .font(
                    .system(size: DEFINE_FONT_SIZE)
                        .weight(.bold)
                )
            } else {
                HStack(spacing: 0) {
                    LocaleText("unlockpro")
                        .font(
                            .system(size: DEFINE_FONT_SMALL_SIZE)
                                .weight(.heavy)
                        )

                    SPACE
                }

                HStack(spacing: 0) {
                    LocaleText("hardworkingdesc", usefirstuppercase: false, linelimit: 3)
                        .font(
                            .system(size: DEFINE_FONT_SMALL_SIZE - 4)
                                .bold()
                        )

                    SPACE.frame(maxWidth: 50)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical)
        .foregroundColor(.white)
    }

    var labelview: some View {
        ZStack {
            preference.theme

            if !permit.purchased {
                imglayer
            }

            textlayer
        }
        .frame(height: 90)
    }

    var body: some View {
        Button {
            trainingmodel.presentprointroduction = true
        } label: {
            labelview
        }
    }
}
