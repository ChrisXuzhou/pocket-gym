//
//  Reviewbetaview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/26.
//

import SwiftUI

struct Reviewbetaview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Reviewbetaview()
        }
    }
}

struct Reviewbetaview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    @StateObject var model = Reviewdatamodel()

    var body: some View {
        Reviewpanel()
            
    }
}
