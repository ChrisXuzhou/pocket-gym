//
//  DatepickerView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/31.
//

import SwiftUI

struct DatepickerView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            DatepickerView(selecteddate: .constant(Date()))
        }
    }
}

struct DatepickerView: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var selecteddate: Date

    var daterange: ClosedRange<Date> {
        let _today = Date()
        let min = Calendar.current.date(byAdding: .day, value: -30, to: _today)!
        let max = Calendar.current.date(byAdding: .day, value: 30, to: _today)!
        return min ... max
    }

    var datepicker: some View {
        HStack {
            DatePicker(
                "",
                selection: $selecteddate,
                in: daterange,
                displayedComponents: .date
            )
            .font(.system(size: DEFINE_FONT_SMALL_SIZE))
            .datePickerStyle(WheelDatePickerStyle())
            .frame(width: 300)
            .environment(\.locale, preference.oflanguage.locale)
        }
    }

    var contentview: some View {
        VStack {
            SPACE

            datepicker

            SPACE

            LocaleText("pleasechooseadatewithinthe90days")
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
                .foregroundColor(NORMAL_GRAY_COLOR)
                .padding(.vertical)
        }
    }

    var body: some View {
        VStack {
            SPACE
            contentview
            SPACE

            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Floatingbutton(label: "confirm",
                               disabled: false,
                               color: preference.theme).padding(.horizontal)
            }
        }
    }
}
