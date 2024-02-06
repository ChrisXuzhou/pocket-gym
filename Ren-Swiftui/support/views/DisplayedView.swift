//
//  DisplayedView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/24.
//
import StoreHelper
import SwiftUI

struct DisplayedView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Text("hello")
        }
    }
}

struct DisplayedView<ButtonsView>: View where ButtonsView: View {
    init(backgroundcolor: Color = NORMAL_BG_COLOR,
         content: @escaping () -> ButtonsView) {
        self.backgroundcolor = backgroundcolor
        self.content = content

        UISegmentedControl.appearance().backgroundColor = UIColor(Color.clear)
    }

    /*

     @StateObject var storeHelper = StoreHelper()
     @StateObject var permit = Permit()

     */

    var backgroundcolor: Color
    let content: () -> ButtonsView

    var body: some View {
        NavigationView {
            ZStack {
                backgroundcolor.ignoresSafeArea()

                self.content()
            }
            .attachLeftslideToRoot()
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .environmentObject(Trainingmodel())
        .environmentObject(PreferenceDefinition())
        .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
        .previewDisplayName("iPhone 12")
        .onTapGesture {
            endtextediting()
        }
    }
}

/*
 .onAppear {
     storeHelper.start()

     Task.init {
         await permit.start(storeHelper)
     }
 }
 .onChange(of: storeHelper.purchasedProducts) { _ in
     Task.init {
         await permit.checkpurchased()
     }
 }

 */
