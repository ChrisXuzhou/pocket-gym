//
//  RestimerView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/16.
//

import SwiftUI

struct RestimerView_Previews: PreviewProvider {
    static var previews: some View {
        let notifier = Localnotifier()

        let timer = Restimer(interval: 10) { _ in
            notifier.sendNotification(title: "Hurray!",
                                      subtitle: nil,
                                      body: "If you see this text, launching the local notification worked!", launchIn: 1)
        }

        DisplayedView(backgroundcolor: NORMAL_THEME_COLOR) {
            VStack {
                RestimerView(restimer: timer)
            }
            .frame(width: REST_TIMER_VIEW_SIZE,
                   height: REST_TIMER_VIEW_SIZE)

            
        }
    }
}

let REST_TIMER_VIEW_SIZE: CGFloat = 80

struct RestimerView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @ObservedObject var restimer: Restimer

    init(restimer: Restimer) {
        self.restimer = restimer
        log("[started] timer ..")
    }

    var ringview: some View {
        RestimerRing(
            restimer: restimer,
            gradientcolors: [preference.theme, preference.themeprimarycolor],
            linewidth: 10
        )
    }

    var restimertext: some View {
        Restimertext(restimer: self.restimer)
    }

    func playorstop() {
        /*
         
         switch restimer.status {
         case .stop:
             restimer.start()
         case .countdown:
             restimer.stop()
         }
         
         
         */
        
    }

    var buttontitle: String {
        /*
         
         
         switch restimer.status {
         case .stop:
             return "Push Start"
         default:
             return "Push Reset"
         }
         
         */
        
        ""
        
    }

    var controlbuttons: some View {
        HStack {
            Button {
                self.playorstop()
            } label: {
                Text(buttontitle)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
        }
    }

    var body: some View {
        VStack {
            ZStack {
                ringview
                restimertext
            }
        }
        .frame(width: REST_TIMER_VIEW_SIZE, height: REST_TIMER_VIEW_SIZE)
    }
}
