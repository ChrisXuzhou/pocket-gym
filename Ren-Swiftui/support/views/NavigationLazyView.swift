//
//  NavigationLazyView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/28.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
