//
//  EquipmentKeyexercisepanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/6.
//

import SwiftUI

struct EquipmentKeyexercisepanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Librarybetaview(showbackbutton: false)
                .navigationBarHidden(true)
        }
    }
}

struct EquipmentKeyexercisepanel: View {
    @ObservedObject var equipmentkeys: EquipmentKeyexercise

    /*
     * function variables
     */
    var keyfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 1
    var keycolor = NORMAL_LIGHTER_COLOR

    var body: some View {
        keyexercisepanels
    }
}

extension EquipmentKeyexercisepanel {
    var equipmentname: some View {
        HStack {
            LocaleText(equipmentkeys.equipmentid)
                .font(.system(size: keyfontsize, design: .rounded).bold())
                .foregroundColor(keycolor)

            SPACE
        }
        .padding(.leading)
    }

    var keyexercisepanels: some View {
        VStack {
            ForEach(equipmentkeys.keys, id: \.self) {
                key in

                if let ke: Keyexercise = equipmentkeys.dictionary[key] {
                    Keyexercisepanel(keyexercise: ke)
                }
            }
        }
    }
}
