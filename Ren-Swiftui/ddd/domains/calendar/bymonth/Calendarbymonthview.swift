import Introspect
import SwiftUI

struct Calendarbymonthview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Calendarbymonthview()
        }
        .environmentObject(Calendarfocusedday())
    }
}

let CALENDAR_SPACING: CGFloat = 3
let CALENDAR_WEEK_HEIGHT: CGFloat = 25
let CALENDAR_ITEM_WIDTH: CGFloat = (UIScreen.width - 30) / 7
let CALENDAR_ITEM_HEIGHT: CGFloat = 125

let CALENDAR_INIT_OFFSET_Y: CGFloat = 2000 * CALENDAR_ITEM_HEIGHT

struct Calendarbymonthview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var focusedday: Calendarfocusedday

    @StateObject var model = Calendarbymonthmodel.shared
    @StateObject var viewmodel = Calendarbymonthviewmodel.shared

    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().showsHorizontalScrollIndicator = false
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            contentview
        }
        .environmentObject(viewmodel)
        .environmentObject(model)
    }
}

extension Calendarbymonthview {
    var weekheader: some View {
        Calendarweekheader()
    }
    
    var calendarweeks: some View {
        ScrollViewReader {
            reader in

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    let _weeks = model.weeks
                    ForEach(_weeks, id: \.self) {
                        _weekdelta in

                        Calendarweek(day: model.ofstartday(_weekdelta))
                            .id(_weekdelta)
                    }
                    .onAppear {
                        withAnimation(Animation.easeInOut) {
                            let _idx = focusedday.focusedday.weeks(from: focusedday.today)
                            reader.scrollTo(_idx, anchor: .center)
                        }
                    }
                    .onChange(of: focusedday.focusedday) { _ in
                        withAnimation(Animation.easeInOut) {
                            let _idx = focusedday.focusedday.weeks(from: focusedday.today)
                            reader.scrollTo(_idx, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    

    var contentview: some View {
        VStack(spacing: 0) {
            weekheader

            calendarweeks
        }
    }
}

/*

 */

/*
 ScrollViewReader {
     reader in
     ScrollView(.vertical, showsIndicators: false) {
         LazyVStack(spacing: 0) {
             let _weeks = model.weeks
             ForEach(_weeks, id: \.self) {
                 _weekdelta in

                 Calendarweek(weekday: model.ofstartday(_weekdelta))
                     .id(_weekdelta)
             }
             .onAppear {
                 withAnimation(Animation.easeInOut) {
                     let _idx = focusedday.focusedday.weeks(from: focusedday.today)
                     reader.scrollTo(_idx, anchor: .center)
                 }
             }
             .onChange(of: focusedday.focusedday) { _ in
                 withAnimation(Animation.easeInOut) {
                     let _idx = focusedday.focusedday.weeks(from: focusedday.today)
                     reader.scrollTo(_idx, anchor: .center)
                 }
             }
         }
     }
 }
 */


/*
 
 var calendarweeks: some View {
     ScrollViewReader {
         reader in

         List {
             ForEach(model.weeks, id: \.self) {
                 _weekdelta in

                 Calendarweek(weekday: model.ofstartday(_weekdelta))
                     .listRowBackground(NORMAL_BG_COLOR)
                     .listRowSeparator(.hidden)
                     .listRowInsets(EdgeInsets())
                     .id(_weekdelta)
             }
         }
         .introspectTableView { tableView in
             tableView.showsVerticalScrollIndicator = false
         }
         .background(NORMAL_BG_COLOR)
         .listStyle(.plain)
         .buttonStyle(BorderlessButtonStyle())
         .onAppear {
             withAnimation(Animation.easeInOut) {
                 let _idx = focusedday.focusedday.weeks(from: focusedday.today)
                 reader.scrollTo(_idx, anchor: .center)
             }
         }
         .onChange(of: focusedday.focusedday) { _ in
             withAnimation(Animation.easeInOut) {
                 let _idx = focusedday.focusedday.weeks(from: focusedday.today)
                 reader.scrollTo(_idx, anchor: .center)
             }
         }
     }
 }
 
 
 var calendarweeks: some View {
     ScrollViewReader {
         reader in

         List {
             ForEach(model.weeks, id: \.self) {
                 _weekdelta in

                 Calendarweek(day: model.ofstartday(_weekdelta))
                     .listRowBackground(NORMAL_BG_COLOR)
                     .listRowSeparator(.hidden)
                     .listRowInsets(EdgeInsets())
                     .id(_weekdelta)
             }
         }
         .introspectTableView { tableView in
             tableView.showsVerticalScrollIndicator = false
         }
         .background(NORMAL_BG_COLOR)
         .listStyle(.plain)
         .buttonStyle(BorderlessButtonStyle())
         .onAppear {
             withAnimation(Animation.easeInOut) {
                 let _idx = focusedday.focusedday.weeks(from: focusedday.today)
                 reader.scrollTo(_idx, anchor: .center)
             }
         }
         .onChange(of: focusedday.focusedday) { _ in
             withAnimation(Animation.easeInOut) {
                 let _idx = focusedday.focusedday.weeks(from: focusedday.today)
                 reader.scrollTo(_idx, anchor: .center)
             }
         }
     }
 }

  */
