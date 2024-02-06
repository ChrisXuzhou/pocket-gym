//
//  Permitplusview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/11/3.
//

import StoreHelper
import StoreKit
import SwiftUI

struct Permitplusview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Permitplusview()
        }
    }
}

let PLUS_ID: String = "com.quantumbubble.pocketfit.plus"

extension StoreHelper {
    static var shared = of()

    private static func of() -> StoreHelper {
        let storehelper = StoreHelper()
        Task.init {
            await storehelper.start()
            log("[store helper] finished..")
        }

        return storehelper
    }

    func donothing() {
    }
}

struct Permitplusview: View {
    
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var present

    @ObservedObject var storehelper: StoreHelper

    init() {
        storehelper = StoreHelper.shared
    }

    /*
     * variables
     */
    @State private var isPurchased: Bool?
    @State private var purchaseState: PurchaseState = .unknown
    @State private var canMakePayments: Bool = false

    @StateObject var showsubs = Viewopenswitch()

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            bgvideo

            ZStack {
                if storehelper.hasStarted {
                    if let _products = storehelper.products {
                        if !_products.isEmpty {
                            ZStack {
                                if let _ispurchased = isPurchased {
                                    if _ispurchased {
                                        purchased
                                    } else {
                                        topurchase
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .task {
                log("[view] purchased fetch ..")
                await checkpurchased()
                log("[view] purchased ..")
            }
            .onChange(of: storehelper.purchasedProducts) { _ in
                Task.init {
                    await checkpurchased()
                }
            }

            VStack {
                upheader

                SPACE
            }
        }
    }

    var topurchase: some View {
        ZStack {
            contentlayer

            operatelayer
        }
    }

    var purchased: some View {
        ZStack {
            purchasedcontentlayer
            
            purchasedoperatelayer
        }
    }
}

extension Permitplusview {
    /*
     * purchase action
     */
    var purchasebutton: some View {
        ZStack {
            let pricemodel = PriceViewModel(storeHelper: storehelper, purchaseState: $purchaseState)
            let disabled = !canMakePayments || purchaseState == .inProgress

            Button {
                withAnimation { purchaseState = .inProgress }
                if let _product = product {
                    Task.init { await pricemodel.purchase(product: _product) }
                }

                log("pressed subscribe")

            } label: {
                Floatingbutton(label: "confirm", color: disabled ? NORMAL_GRAY_COLOR : preference.theme)
            }
            .padding(.horizontal)
            .disabled(disabled)
        }
    }

    func checkpurchased() async {
        canMakePayments = AppStore.canMakePayments

        if !canMakePayments {
            return
        }

        storehelper.start()
        log("[store helper] finished.. before use")

        if let purchased = try? await storehelper.isPurchased(productId: PLUS_ID) {
            isPurchased = purchased

            log("[purchase check] \(purchased)")
        }
    }

    var product: Product? {
        let product = storehelper.product(from: PLUS_ID)
        return product
    }
}

extension Permitplusview {
    var bgvideo: some View {
        VStack(spacing: 0) {
            VideoView(v: "cloud_video", rate: 0.5)
                .frame(width: UIScreen.width, height: UIScreen.width * 240 / 426)
                .animationsDisabled()
                .overlay {
                    NORMAL_BG_COLOR.opacity(0.7)
                }

            SPACE
        }
    }

    var operatelayer: some View {
        VStack {
            SPACE

            purchasebutton

            privacyandterms
        }
        .padding(.top, 10)
    }

    var upheader: some View {
        HStack {
            Button {
                present.wrappedValue.dismiss()
            } label: {
                Closeshape(imgsize: 30, fontsize: 26)
                    .opacity(0.6)
            }
            .foregroundColor(NORMAL_BUTTON_COLOR)

            SPACE
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
    }

    var privacyandterms: some View {
        HStack(spacing: 12) {
            SPACE
            Linklabel(label: Privacyandtermstype.terms.label,
                      url: Privacyandtermstype.terms.url
            )
            Linklabel(label: Privacyandtermstype.privacy.label,
                      url: Privacyandtermstype.privacy.url
            )
            Button {
                Task.init {
                    try? await AppStore.sync()
                }
            } label: {
                LocaleText("restore")
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
                    .foregroundColor(NORMAL_LIGHT_BUTTON_COLOR)
            }
            SPACE
        }
        .padding(.top)
    }
}

extension Permitplusview {
    var contentlayer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                SPACE.frame(height: 250)

                HStack {
                    pluslogo
                    SPACE
                }

                unlockheadine

                unlockdesc

                feelabel
            }
            .padding(.horizontal, 20)
        }
    }

    var pluslogo: some View {
        HStack {
            LocaleText(LANGUAGE_APPNAME)
                .foregroundColor(NORMAL_BUTTON_COLOR.opacity(0.7))
                .font(.system(size: DEFINE_FONT_SIZE + 3).weight(.heavy))

            Text("PLUS")
                .font(.system(size: DEFINE_FONT_SIZE - 2, design: .rounded).weight(.heavy))
                .foregroundColor(preference.theme)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(preference.themesecondarycolor)
                )
        }
    }

    var unlockheadine: some View {
        LocaleText("unlockheadline", usefirstuppercase: false, linespacing: 5)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .font(.system(size: 25).weight(.heavy))
            .padding(.vertical, 1)
    }

    var unlockdesc: some View {
        LocaleText("unlockdesc", usefirstuppercase: false, linelimit: 10)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .font(.system(size: 15))
            .padding(.vertical, 10)
    }

    var feelabel: some View {
        ZStack {
            let fee: String = product?.displayPrice ?? preference.language("monthlyfee")

            HStack(alignment: .lastTextBaseline, spacing: 5) {
                LocaleText(fee, linelimit: 5)
                    .font(.system(size: 40).bold())

                SPACE
            }
            .foregroundColor(preference.theme)
            .padding(.vertical, 5)
        }
    }
}

/*
 TempPermitplusview
 Permitplusview
 */
extension Permitplusview {
    var purchasedcontentlayer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                SPACE.frame(height: 250)

                HStack {
                    pluslogo
                    SPACE
                }

                purchasedheadine

                purchaseddesc

                purchasedcontact.padding(.top, 20)

            }
            .padding(.horizontal, 20)
        }
    }

    var purchasedcontact: some View {
        HStack {
            let _contactustype = Contactustype.twitter

            if preference.oflanguage == .simpledchinese {
                HStack(spacing: 10) {
                    Image("email")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 26, height: 22, alignment: .center)
                        .padding(.top, 8)

                    Text("bbetterchris@gmail.com")
                        .accentColor(NORMAL_GRAY_COLOR.opacity(0.6))
                        .font(.system(size: COPYRIGHT_FONT_SIZE))
                        .multilineTextAlignment(.center)
                        .frame(height: 40)
                }
                .foregroundColor(NORMAL_GRAY_COLOR.opacity(0.6))
            } else {
                Button {
                    forwardto(_contactustype)
                } label: {
                    HStack(spacing: 0) {
                        Contactuslogo(istwitter: _contactustype == .twitter, imgsize: 38, color: NORMAL_GRAY_COLOR.opacity(0.6))
                            .frame(height: 40)

                        Text("@betterchris")
                            .font(.system(size: COPYRIGHT_FONT_SIZE))
                            .frame(height: 40)
                    }
                    .foregroundColor(NORMAL_GRAY_COLOR.opacity(0.6))
                }
            }
            
            SPACE
        }
    }

    var purchasedheadine: some View {
        LocaleText("purchasedheadline", usefirstuppercase: false, linespacing: 5)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .font(.system(size: 25).weight(.heavy))
            .padding(.vertical, 1)
    }

    var purchaseddesc: some View {
        LocaleText("purchaseddesc", usefirstuppercase: false, linelimit: 10)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .font(.system(size: 15))
            .padding(.vertical, 10)
    }

    var managesubscriptions: some View {
        ZStack {
            Button {
                showsubs.value = true
            } label: {
                Floatingbutton(label: "viewsubscription", color: preference.theme)
            }
            .manageSubscriptionsSheet(isPresented: $showsubs.value)
            .padding(.horizontal)
        }
    }

    var purchasedoperatelayer: some View {
        VStack {
            SPACE

            // managesubscriptions

            privacyandterms
        }
        .padding(.top, 10)
    }
}
