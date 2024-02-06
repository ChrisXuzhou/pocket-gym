//
//  CustomizeplanView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI


struct CustomizeplanView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            CustomizeplanView(present: .constant(true))
        }
        .environmentObject(CustomizeModel())
    }
}

struct CustomizeplanView: View {
    @Binding var present: Bool

    var body: some View {
        VStack {
            Fitnesslevelquestion(present: $present)
        }
        
    }
}
