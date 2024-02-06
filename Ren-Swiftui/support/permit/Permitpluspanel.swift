//
//  Permitpluspanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/11/3.
//

import StoreHelper
import StoreKit
import SwiftUI

struct Permitpluspanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Permitpluspanel()
        }
    }
}

class Permitpluscheck: ObservableObject {
    /*
     * variables
     */
    @Published var isPurchased: Bool?
    @Published var purchaseState: PurchaseState = .unknown
    @Published var canMakePayments: Bool = false

    init() {
        refresh()
    }

    func refresh() {
        Task {
            log("[Task] begin sleep.")
            try! await Task.sleep(seconds: 1.5)

            log("[Task] finish sleep.")
            await checkpurchased()
            log("[Task] finish check.")
        }
    }

    private func checkpurchased() async {
        let canMakePayments = AppStore.canMakePayments

        if !canMakePayments {
            return
        }

        await StoreHelper.shared.start()
        log("[store helper] finished.. before use")

        if let purchased = try? await StoreHelper.shared.isPurchased(productId: PLUS_ID) {
            DispatchQueue.main.async {
                self.isPurchased = purchased
            }

            log("[purchase check] \(purchased)")
            
        }
    }
}

struct Permitpluspanel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    /*
     * variables
     */
    @ObservedObject var storehelper = StoreHelper.shared
    @StateObject var checker = Permitpluscheck()
    @StateObject var opensubsview = Viewopenswitch()

    var body: some View {
        ZStack {
            preference.theme

            HStack(spacing: 0) {
                /*
                 
                     Image("dumbbell")
                         .renderingMode(.template)
                         .resizable()
                         .frame(width: 30, height: 30)
                         .aspectRatio(contentMode: .fill)
                         .foregroundColor(.white)
                         .frame(width: 50, height: 30)
                 */
                
                VStack(alignment: .leading, spacing: 3) {
                    header

                    details
                }

                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .contentShape(Rectangle())
        .onTapGesture {
            opensubsview.value.toggle()
        }
        .sheet(isPresented: $opensubsview.value) {
            Permitplusview()
        }
    }
}

extension Permitpluspanel {
    var header: some View {
        HStack(spacing: 5) {
            LocaleText(LANGUAGE_APPNAME)
                .foregroundColor(.white)

            Text("PLUS")
                .foregroundColor(preference.theme)
                .font(.system(size: DEFINE_FONT_SIZE - 2).weight(.bold))
                .padding(.vertical, 1)
                .padding(.horizontal, 5)
                .background(
                    Color.white.opacity(0.7)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))

            SPACE
        }
        .font(.system(size: DEFINE_FONT_SIZE).weight(.bold))
    }

    var details: some View {
        ZStack {
            if let _ispurchased = checker.isPurchased {
                HStack {
                    LocaleText(_ispurchased ? "perchasedshortdesc" : "unlockheadlinesum", usefirstuppercase: false, linelimit: 2, linespacing: 0)
                    SPACE
                }
                .foregroundColor(.white)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2))
            }
        }
        .onChange(of: storehelper.purchasedProducts) { _ in
            checker.refresh()
        }
    }
}
