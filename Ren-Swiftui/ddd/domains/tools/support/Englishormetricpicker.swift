//
//  Englishormetric.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/22.
//

import SwiftUI

struct Englishormetric_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Englishormetricpicker(picked: .constant(.english))
        }
    }
}

let ENGLISH_OR_METRIC_LIST: [Englishormetric] = [.english, .metric]

struct Englishormetricpicker: View {
    
    @Binding var picked: Englishormetric
    
    var body: some View {
        HStack(spacing: MIDDLE_SPACING) {
            SPACE

            HStack(spacing: 0) {
                Picker("", selection: $picked) {
                    ForEach(ENGLISH_OR_METRIC_LIST, id: \.self) {
                        LocaleText($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .contentShape(Rectangle())
                .onTapGesture {
                    if picked == .english {
                        picked = .metric
                    } else {
                        picked = .english
                    }
                }
            }
            .frame(width: 150)

            SPACE
        }
        
    }
}
