//
//  BoardingView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/15.
//

import SwiftUI

struct BoardingView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            BoardingView()
        }
    }
}


struct BoardingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NORMAL_BG_COLOR.ignoresSafeArea()

                BoardingPages()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}
