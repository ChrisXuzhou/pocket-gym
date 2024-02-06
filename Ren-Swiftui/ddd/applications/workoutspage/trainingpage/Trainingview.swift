//
//  PlanprogramView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/21.
//

import SwiftUI

struct Trainingview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ScrollView(.vertical, showsIndicators: false) {
                Trainingview()
            }
        }
    }
}

let NEW_A_TEMPLATE_WIDTH: CGFloat = UIScreen.width
let NEW_A_TEMPLATE_HEIGHT: CGFloat = 65

struct Trainingview: View {
    @StateObject var pagedto: Pagedtoplanorroutine = Pagedtoplanorroutine()

    var body: some View {
        VStack(spacing: 10) {

            // Reviewcard()
            
            // LOCAL_DIVIDER

            content
        }
    }

    var content: some View {
        ZStack(alignment: .top) {
            
            SPACE.frame(height: UIScreen.height)

            VStack {
                Routinetreeview()

                Copyright()

                SPACE.frame(height: MIN_UP_TAB_HEIGHT)
            }
            .padding(.horizontal, 10)
        }
    }
}

/*
 
 VStack {
     Programorroutinemenu()
         .environmentObject(pagedto)

     
 }
 
 switch pagedto.pagedto {
 case .plans:
     programs
 case .routines:
     routines
 }
 
 var programs: some View {
     Programsview()
         .padding(.top)
 }

 var routines: some View {
     Routinetreeview()
 }
 
 */
