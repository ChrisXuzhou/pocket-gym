//
//  Updatesview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/13.
//
import SwiftUI
import Updates

struct Updatesview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ZStack {
                NORMAL_BANANA_COLOR
                    .ignoresSafeArea()

                Updatesview()
            }
        }
    }
}

struct Updatesview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UpdatesViewController {
        UpdatesViewController()
    }

    func updateUIViewController(_ updatesViewController: UpdatesViewController, context: Context) {
        // update
    }
}
