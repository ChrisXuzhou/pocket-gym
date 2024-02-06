//
//  Batchtag.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/11.
//

import SwiftUI

struct Batchtaglist_Previews: PreviewProvider {
    static var previews: some View {
        
        DisplayedView {
            VStack(spacing: 20) {
                Batchtaglist(batch: Batch(num: 0, workoutid: -1, type: .warmup),
                             batchcount: 1)

                Batchtaglist(batch: Batch(num: 0, workoutid: -1, type: .warmup),
                             batchcount: 2)
            }
            .padding()
        }
    }
}

struct Batchtaglist: View {
    var batch: Batch
    var batchcount: Int?

    var batchtypeview: some View {
        HStack {
            var type = batch.oftype
            
            if type != .workout {
                Tagicon(tag: type.rawValue,
                        color: type.color)
            }
        }
    }

    var batchcountview: some View {
        HStack {
            if let _s = Super.of(batchcount) {
                Tagicon(tag: _s.rawValue,
                        color: NORMAL_SUPER_COLOR)
            }
        }
    }

    var body: some View {
        HStack {
            batchtypeview

            batchcountview

            SPACE
        }
    }
}

let TAG_ICON_SIZE: CGFloat = 20

struct Tagicon: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var tag: String
    var color: Color = NORMAL_BUTTON_COLOR

    var body: some View {
        Text(preference.language(tag))
            .lineLimit(2)
            .minimumScaleFactor(0.01)
            .multilineTextAlignment(.center)
            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 4).bold())
            .foregroundColor(.white)
            .padding(3)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(color)
                    .shadow(color: NORMAL_LIGHT_GRAY_COLOR, radius: 2, x: 1, y: 0)
            )
    }
}
