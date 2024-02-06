//
//  Recoverpanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/9.
//

import SwiftUI

struct Recoverpanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Recoverpanel()
        }
    }
}

struct Recoverpanel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @StateObject var recoverconfirm = Viewopenswitch()
    @State var showmessage: Bool = false

    var body: some View {
        VStack {
            recovermessage
                .padding(.horizontal, 25)

            recoverbutton
        }
    }
}

extension Recoverpanel {
    var recovermessage: some View {
        ZStack {
            if showmessage {
                VStack {
                    LocaleText("recoverymessage",
                               usefirstuppercase: false, linespacing: 5)
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                        .foregroundColor(NORMAL_RED_COLOR.opacity(0.7))
                }

                .padding(.vertical, 10)
            }
        }
    }

    var recoverbutton: some View {
        Button {
            recoverconfirm.value = true
        } label: {
            ZStack {
                preference.theme

                VStack {
                    SPACE.frame(height: 70)

                    Cloudshape(upload: false, imgsize: 32)

                    LocaleText("datarecovery", usefirstuppercase: false)
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())

                    SPACE
                }
            }
            .foregroundColor(.white)
            .frame(width: BACKUP_BUTTON_WIDTH, height: BACKUP_BUTTON_HEIGHT)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .confirmationDialog(
            Text(preference.language("datarecovery") + "?"),
            isPresented: $recoverconfirm.value,
            titleVisibility: .visible
        ) {
            Button {
                DispatchQueue.global().async {
                    Backupadaptor.shared.recoverrecordbackups(-1)
                    Backupadaptor.shared.recoverexercisebackups(-1)
                }

                showmessage = true
            } label: {
                LocaleText("ok")
            }
        }
    }
}
