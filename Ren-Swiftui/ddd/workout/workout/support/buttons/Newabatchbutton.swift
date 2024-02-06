//
//  Newabatchbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

struct Newabatchbutton: View {
    @EnvironmentObject var model: Workoutmodel
    @EnvironmentObject var preference: PreferenceDefinition

    @StateObject var showlibrary = Viewopenswitch()

    var body: some View {
        buttonlable
            .fullScreenCover(isPresented: $showlibrary.value) {
                NavigationView {
                    LibraryaddView(workoutaction: model) {
                        showlibrary.value = false
                    }
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                }
            }
    }
}

extension Newabatchbutton {
    var buttonlable: some View {
        Button {
            showlibrary.value = true
        } label: {
            HStack {
                SPACE

                Image(systemName: "plus.circle.fill")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .background(
                        Circle()
                            .foregroundColor(.white)
                            .padding(1)
                    )
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(
                        preference.theme
                    )

                SPACE
            }
        }
    }
}
