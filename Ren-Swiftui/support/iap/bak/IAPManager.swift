//
//  IAPManager.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/15.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
    static let shared = IAPManager()
    var products = [SKProduct]()
    fileprivate var productRequest: SKProductsRequest!
    func getProductIDs() -> [String] {
        ["com.quantumbubble.pocketfit.pro.mly"]
    }

    func getProducts() {
        let productIds = getProductIDs()
        let productIdsSet = Set(productIds)
        productRequest = SKProductsRequest(productIdentifiers: productIdsSet)
        productRequest.delegate = self
        productRequest.start()
    }

    func buy(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            // show error
        }
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.products.forEach {
            log("\($0.localizedTitle)  \($0.price)  \($0.localizedDescription) ")
        }
        products = response.products
    }
}
