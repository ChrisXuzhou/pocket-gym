//
//  Contactusmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/20.
//

import Foundation

enum Contactustype {
    case weibo, twitter

    var deeplink: String {
        switch self {
        case .weibo:
            return "https://weibo.com/u/7763205579"
        case .twitter:
            return "twitter://user?screen_name=BBetterchris"
        }
    }
    
    var urllink: String {
        switch self {
        case .weibo:
            return "https://weibo.com/u/7763205579"
        case .twitter:
            return "https://twitter.com/BBetterchris"
        }
    }
}
