//
//  DataView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/7.
//

import SwiftUI

struct Reviewview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Reviewview()
        }
    }
}

class Reviewpagedto: ObservableObject {
    @Published var pagedto: Reviewtype

    init() {
        var type: Reviewtype = .statistic

        if let _cache = AppDatabase.shared.queryappcache(REVIEW_TYPE_KEY) {
            type = Reviewtype(rawValue: _cache.cachevalue) ?? .statistic
        }

        _pagedto = .init(initialValue: type)
    }
}

struct Reviewview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    @StateObject var pagedto = Reviewpagedto()

    var body: some View {
        Reviewbetaview()
    }
}

enum Reviewtype: String, CaseIterable {
    case frequency, statistic

    var index: Int {
        switch self {
        case .frequency:
            return 0
        case .statistic:
            return 1
        }
    }
}

let REVIEW_TYPE_KEY: String = "reviewviewtypekey"

extension Reviewview {
    var menupanel: some View {
        Picker("", selection: $pagedto.pagedto) {
            ForEach(Reviewtype.allCases, id: \.self) {
                LocaleText($0.rawValue, usefirstuppercase: false)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                    .tag($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .padding(.horizontal)
    }

}

/*
 
 
 struct ReviewviewmenuIcon: View {
     @EnvironmentObject var preference: PreferenceDefinition
     var description: String
     var selected: Bool

     var body: some View {
         VStack(spacing: 0) {
             SPACE

             LocaleText(description, usefirstuppercase: false)
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                 .foregroundColor(selected ? preference.theme : NORMAL_BUTTON_COLOR)

             SPACE
         }
         .frame(width: UIScreen.width / CGFloat(Activitymuscledatatype.allCases.count),
                height: 45
         )
     }
 }

 
 */
