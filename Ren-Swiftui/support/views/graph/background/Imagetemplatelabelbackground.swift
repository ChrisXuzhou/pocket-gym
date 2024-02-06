//
//  ImageMusclebackground.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//

import SwiftUI

struct ImageMusclebackground_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
        }
    }
}

struct Imagetemplatelabelbackground: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var body: some View {
        GeometryReader {
            reader in

            ZStack {
                Color.gray.ignoresSafeArea()

                preference.theme.opacity(0.2)
            }
            .frame(height: reader.size.height)
            .clipped()
            .contentShape(Rectangle())
        }
    }
}
