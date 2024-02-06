//
//  RouterView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/17.
//

import SwiftUI

struct RouterView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            RouterView()
                .environmentObject(Routermodel())
        }
    }
}

struct RouterView: View {
    @StateObject var model =  Routermodel.shared

    var body: some View {
        ZStack {
            if model.appidentity == nil {
                BoardingView()
                    .environmentObject(model)
            } else {
                Homepageview()
            }
        }
        .background(
            NORMAL_BG_COLOR.ignoresSafeArea()
        )
    }
}
