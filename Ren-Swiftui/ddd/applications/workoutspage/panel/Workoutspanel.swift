//
//  Workoutspanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/12/2.
//

import SwiftUI

struct Workoutspanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

struct Workoutspanel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var routinesmodel: Folderroutinesmodel

    var body: some View {
        HStack {
            focus
            
            plans

            SPACE

            routinescount
        }
        .frame(height: 70)
        .padding(.top, 10)
        .padding(.leading)
        .padding(.trailing, 10)
    }

    var plans: some View {
        NavigationLink {
            Programsview()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } label: {
            Defaultpanel(name: "programs", image: Image("clock"))
        }
    }

    var focus: some View {
        NavigationLink {
            Workoutsfocusedview()
                .environmentObject(routinesmodel)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } label: {
            Defaultpanel(name: "mark", image: Image("bookmark"))
        }
    }

    var routinescount: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("\(routinesmodel.templates.count)")
                .font(.system(size: 40).weight(.semibold))
                .foregroundColor(preference.theme)
            LocaleText("routines")
                .font(.system(size: 10).weight(.semibold))
                .foregroundColor(NORMAL_GRAY_COLOR)
        }
    }
}

struct Defaultpanel: View {
    var name: String
    var image: Image

    /*
     * variables
     */
    var width: CGFloat = 25
    var height: CGFloat = 25

    var body: some View {
        VStack {
            image
                .resizable()
                .frame(width: width, height: height)
                .aspectRatio(contentMode: .fit)

            SPACE

            LocaleText(name)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
                .foregroundColor(NORMAL_LIGHTER_COLOR)
        }
        .frame(height: 55)
    }
}
