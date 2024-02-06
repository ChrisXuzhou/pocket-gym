//
//  PromembershipView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/6.
//

import StoreHelper
import StoreKit
import SwiftUI

struct PromembershipView_Previews: PreviewProvider {
    static var previews: some View {
        let storeHelper = StoreHelper()

        DisplayedView {
            PromembershipView(productid: "pro.mly")
        }
        .environmentObject(storeHelper)
        .onAppear { storeHelper.start() }
    }
}

struct PromembershipView: View {
    @EnvironmentObject var storeHelper: StoreHelper
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var present

    @State var purchaseState: PurchaseState = .unknown
    var productid: String

    init(purchaseState: PurchaseState = .unknown, productid: String) {
        _purchaseState = .init(initialValue: purchaseState)
        self.productid = productid
    }

    var uptabview: some View {
        HStack {
            SPACE

            Button {
                present.wrappedValue.dismiss()

            } label: {
                Closeshape(imgsize: 30)
                    .foregroundColor(preference.theme)
            }
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
    }

    var titleview: some View {
        VStack(spacing: 1) {
            LocaleText("pro")
                .font(.system(size: DEFINE_FONT_BIGGEST_SIZE * 2).weight(.heavy))
                .foregroundColor(NORMAL_GOLD_COLOR)

            SmallLogo(showimg: false,
                                color: NORMAL_GRAY_COLOR)
                .padding(.bottom, 15)

            if purchaseState != .purchased {
                LocaleText("prosubtitle")
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
                    .foregroundColor(NORMAL_GRAY_COLOR)
                    .padding(.bottom, 10)
            }

            Divider()
        }
        .frame(height: 120)
    }

    var descriptionlabel: some View {
        Functiondisplayedlabellist()
            .padding(.top, 30)
    }

    var paybutton: some View {
        VStack {
            if let product = storeHelper.product(from: productid) {
                let disabled: Bool = purchaseState == .inProgress

                Purchasebutton(purchaseState: $purchaseState,
                               product: product, disabled: disabled)
                    .disabled(disabled)
            }
        }
    }

    var paybenifits: some View {
        VStack(spacing: 8) {
            LocaleText("probenifits",
                       usefirstuppercase: false,
                       linelimit: 4,
                       alignment: .center,
                       linespacing: 5
            )
            .frame(height: 60)

            let _free = preference.language("freelimit", firstletteruppercase: false)
                .replacingOccurrences(of: "{TIMES}", with: "\(FREE_WORKOUTS_LIMIT)")

            LocaleText(_free,
                       usefirstuppercase: false,
                       alignment: .center,
                       linespacing: 5)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2).bold())
                .foregroundColor(preference.theme)
                .frame(height: 30)
        }
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2).bold())
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(maxWidth: UIScreen.width - 40)
        .padding(.vertical, 15)
    }

    var paynotes: some View {
        VStack(spacing: 5) {
            LocaleText("paymentnotes",
                       usefirstuppercase: false,
                       linelimit: 10,
                       alignment: .center,
                       linespacing: 5
            )
        }
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
        .foregroundColor(NORMAL_GRAY_COLOR)
        .padding(.horizontal)
        .padding(.vertical, 15)
        .onChange(of: storeHelper.purchasedProducts) { _ in
            Task.init {
                await purchaseState(for: productid)
            }
        }
    }

    var titleanddescription: some View {
        VStack {
            uptabview

            titleview

            descriptionlabel
        }
    }

    var payoperation: some View {
        VStack {
            if purchaseState != .purchased {
                paybutton

                paybenifits
            } else {
                ViewsubscriptionButton()
            }
        }
        .padding(.top, 30)
    }

    var privacyandterms: some View {
        Privacyandterms()
    }

    var statements: some View {
        paynotes
            .padding(.horizontal)
    }

    @State private var purchasesRestored: Bool = false

    private func restorePurchases() {
        Task.init {
            try? await AppStore.sync()
            purchasesRestored.toggle()
        }
    }

    var restorepurchasebutton: some View {
        Button {
            restorePurchases()
        } label: {
            Text(preference.language("restorepurchases"))
                .underline()
                .tracking(0.5)
                .lineLimit(1)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                .foregroundColor(
                    purchasesRestored ?
                        NORMAL_BUTTON_COLOR : preference.theme)
        }
        .disabled(purchasesRestored)
    }

    var contentview: some View {
        VStack {
            titleanddescription

            payoperation

            Divider().padding(.vertical)

            statements

            restorepurchasebutton
                .padding(.vertical)

            privacyandterms

            SPACE.frame(height: MIN_UP_TAB_HEIGHT)
        }
        .frame(minHeight: UIScreen.height)
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                contentview
            }
        }
    }

    func purchaseState(for productId: String) async {
        let purchased = (try? await storeHelper.isPurchased(productId: productId)) ?? false
        purchaseState = purchased ? .purchased : .unknown
    }
}
