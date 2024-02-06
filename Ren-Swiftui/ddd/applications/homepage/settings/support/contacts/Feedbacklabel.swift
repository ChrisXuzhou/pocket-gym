//
//  Contactsview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/20.
//

import SwiftUI

struct Feedbacklabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Feedbacklabel()
        }
    }
}

func forwardto(_ contactustype: Contactustype) {
    let instagramHooks = contactustype.deeplink
    let instagramUrl = URL(string: instagramHooks)!
    if UIApplication.shared.canOpenURL(instagramUrl) {
        UIApplication.shared.open(instagramUrl)
    } else {
        UIApplication.shared.open(URL(string: contactustype.urllink)!)
    }
}

// let FEEDBACK = AnyView(Feedbacklabel().padding(.vertical, 30))

struct Feedbacklabel: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    var showtext = true


    var contactbutton: some View {
        VStack(spacing: 5) {
            let _contactustype = Contactustype.twitter // preference.ofcontacttype

            if preference.oflanguage != .simpledchinese {
                Button {
                    forwardto(_contactustype)
                } label: {
                    VStack {
                        Contactuslogo(istwitter: _contactustype == .twitter, imgsize: 38)

                        Text("@betterchris")
                            .font(.system(size: COPYRIGHT_FONT_SIZE))
                    }
                    .foregroundColor(NORMAL_GRAY_COLOR)
                }
                
                Text("bbetterchris@gmail.com")
                    .font(.system(size: COPYRIGHT_FONT_SIZE))
                
            } else {
                LocaleText("contactus")
                    .font(.system(size: COPYRIGHT_FONT_SIZE))
                
                Text("bbetterchris@gmail.com")
                    .font(.system(size: COPYRIGHT_FONT_SIZE))
                    .padding(.top, 2)
            }
        }
        .foregroundColor(NORMAL_GRAY_COLOR.opacity(0.6))
    }

    var noteview: some View {
        VStack(spacing: 10) {
            contactbutton
            
            HStack {
                SPACE
            }
            .frame(height: 30)
        }
        .padding(.horizontal)
        .padding(.vertical, 30)
    }

    var body: some View {
        noteview
    }
}
