//
//  Subscribelabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/6.
//

import StoreHelper
import StoreKit
import SwiftUI

let SUBSCRIBE_LABEL_HEIGHT: CGFloat = 45 // (UIScreen - 40) / 3
let SUBSCRIBE_LABEL_WIDTH: CGFloat = 120
let BUTTON_WIDTH: CGFloat = UIScreen.width - 40 - SUBSCRIBE_LABEL_WIDTH

struct Purchasebutton: View {
    @EnvironmentObject var storeHelper: StoreHelper
    @EnvironmentObject var preference: PreferenceDefinition

    @State private var canMakePayments: Bool = false
    @Binding var purchaseState: PurchaseState
    var description: String? = "billedmonthly"
    var product: Product

    var disabled: Bool = false

    var body: some View {
        VStack {
            let priceViewModel = PriceViewModel(storeHelper: storeHelper, purchaseState: $purchaseState)

            Button {
                withAnimation { purchaseState = .inProgress }
                Task.init { await priceViewModel.purchase(product: product) }
            } label: {
                HStack(spacing: 0) {
                    button
                    lableview
                }
            }
            .disabled(!canMakePayments)
        }
        .onAppear { canMakePayments = AppStore.canMakePayments }
    }

    var button: some View {
        HStack {
            LocaleText("continue", uppercase: true)
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        .foregroundColor(.white)
        .frame(width: BUTTON_WIDTH, height: SUBSCRIBE_LABEL_HEIGHT)
        .background(
            Rectangle()
                .cornerRadius(12, corners: [.bottomLeft, .topLeft])
                .foregroundColor(
                    disabled ?
                        NORMAL_LIGHT_GRAY_COLOR :
                        preference.theme)
        )
    }

    var lableview: some View {
        VStack(spacing: 3) {
            currency
            descriptionlabel
        }
        .foregroundColor(.white)
        .frame(width: SUBSCRIBE_LABEL_WIDTH, height: SUBSCRIBE_LABEL_HEIGHT)
        .background(
            Rectangle()
                .cornerRadius(12, corners: [.bottomRight, .topRight])
                .foregroundColor(
                    disabled ?
                        NORMAL_LIGHT_GRAY_COLOR :
                        preference.themeprimarycolor
                )
        )
    }

    var descriptionlabel: some View {
        HStack {
            if let _description = description {
                LocaleText(_description, uppercase: true)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 4).bold())
            }
        }
    }

    var currency: some View {
        HStack(spacing: 5) {
            let _price = product.displayPrice

            SPACE
            LocaleText(_price)
            LocaleText("mly", usefirstuppercase: false)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
            SPACE
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
    }
}

struct ViewsubscriptionButton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ViewsubscriptionButton()
        }
    }
}

struct ViewsubscriptionButton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @State private var showManageSubscriptionsSheet = false

    var buttonlabel: some View {
        VStack(spacing: 3) {
            LocaleText("viewsubscription")
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        .foregroundColor(.white)
        .frame(width: UIScreen.width - 40, height: SUBSCRIBE_LABEL_HEIGHT)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(
                    preference.theme
                )
        )
    }

    var body: some View {
        VStack {
            Button {
                showManageSubscriptionsSheet.toggle()
            } label: {
                buttonlabel
            }
            .manageSubscriptionsSheet(isPresented: $showManageSubscriptionsSheet)
            .animationsDisabled()
        }
    }
}

/*
 
 
 struct RefundButton: View {
     @EnvironmentObject var preference: PreferenceDefinition
     @State private var showRefundSheet = false

     var buttonlabel: some View {
         VStack(spacing: 3) {
             LocaleText("refund")
         }
         .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
         .foregroundColor(.white)
         .frame(width: UIScreen.width - 40, height: SUBSCRIBE_LABEL_HEIGHT)
         .background(
             RoundedRectangle(cornerRadius: 12)
                 .foregroundColor(
                     NORMAL_BUTTON_COLOR
                 )
         )
     }

     var body: some View {
         VStack {
             Button {
                 showRefundSheet.toggle()
             } label: {
                 buttonlabel
             }
             .refundRequestSheet(for: refundRequestTransactionId, isPresented: $showRefundSheet) { refundRequestStatus in
                 switch refundRequestStatus {
                 case .failure: refundAlertText = "Refund request submission failed"
                 case .success: refundAlertText = "Refund request submitted successfully"
                 }
             }

             .animationsDisabled()
         }
     }
 }
 
 */
