//
//  Calendarsidebar.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/1.
//

import SwiftUI

struct Calendarsidebar_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Calendarsidebar(present: .constant(true))
                .environmentObject(Calendarmodel())
        }
    }
}

struct Calendarsidebar: View {
    @Binding var present: Bool
    @EnvironmentObject var model: Calendarmodel

    var calendarselectorbar: some View {
        VStack(spacing: 0) {
            ForEach(Calendartype.allCases, id: \.self) {
                calendartype in

                Calendarselector(present: $present,
                                 focused: $model.calendartype,
                                 type: calendartype,
                                 img: "view-\(calendartype.rawValue)")
            }
        }
    }

    var logo: some View {
        HStack {
            LocaleText("workoutscalendar")
                .font(
                    .system(size: DEFINE_FONT_SIZE, design: .rounded)
                    
                        //.weight(.bold)
                )
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
    }

    var commonsettingsbar: some View {
        VStack {
            // Settingsbar()
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            logo

            Divider()

            calendarselectorbar

            Divider()
                .padding(.top, 30)

            commonsettingsbar

            SPACE
        }
    }
}

struct Calendarselector: View {
    @Binding var present: Bool
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var focused: Calendartype

    var type: Calendartype
    var img: String

    var imgsize: CGFloat = 20

    var isfocused: Bool {
        focused == type
    }

    var body: some View {
        ZStack {
            if isfocused {
                preference.themeprimarycolor
            }

            HStack(spacing: 0) {
                Image(img)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imgsize, height: imgsize, alignment: .center)
                    .padding(.trailing, 8)
                    .foregroundColor(NORMAL_BUTTON_COLOR)

                LocaleText(type.rawValue)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE + 1))

                SPACE
            }
            .padding(.horizontal)
            .foregroundColor(NORMAL_COLOR)
        }
        .frame(height: LIST_ITEM_HEIGHT)
        .contentShape(Rectangle())
        .onTapGesture {
            focused = type
            present = false

            DispatchQueue.global().async {
                var appcache = Appcache(cachekey: CALENDAR_TYPE_KEY, cachevalue: type.rawValue)
                try! AppDatabase.shared.saveappcache(&appcache)
            }
        }
    }
}

public var CALENDAR_TYPE_KEY: String = "calendartype"
