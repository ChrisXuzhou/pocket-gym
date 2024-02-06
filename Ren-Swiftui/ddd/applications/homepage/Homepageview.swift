//
//  HomepageView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/18.
//


import SwiftUI

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Homepageview()
        }
        .environmentObject(Trainingmodel())
    }
}

struct CaptionLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .scaleEffect(0.8, anchor: .center)
                .frame(width: 20, height: 20, alignment: .center)

            configuration.title
        }
        .font(.caption)
    }
}

struct Homepageview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @StateObject var pageddomain: Pageddomain = Pageddomain.shared

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack {
            TabView(selection: $pageddomain.pageddomain) {
                workouts
                    .tag(Homedomain.workouts)

                calendar
                    .tag(Homedomain.calendar)

                library
                    .tag(Homedomain.library)

                settings
                    .tag(Homedomain.settings)
            }

            Traininglayer()
        }
    }
}

extension Homepageview {
    /*
     * control page: multi-operate buttons
     */
    var menu: some View {
        VStack {
            SPACE

            Homepagemenu()
        }
        .environmentObject(pageddomain)
        .ignoresSafeArea(.keyboard)
    }

    private var settings: some View {
        NavigationView {
            ZStack {
                Settingsbetaview()

                menu
            }
            .navigationBarTitle("\(preference.language(Homedomain.settings.rawValue))", displayMode: .large)
        }
    }

    private var library: some View {
        NavigationView {
            ZStack {
                Libraryfacadeview()

                menu
            }
            .navigationBarTitle("\(preference.language(Homedomain.library.rawValue))", displayMode: .large)
        }
    }

    private var workouts: some View {
        NavigationView {
            ZStack {
                Workoutsview()

                menu
            }.navigationBarTitle("\(preference.language(Homedomain.workouts.rawValue))", displayMode: .large)
        }
    }

    private var calendar: some View {
        NavigationView {
            ZStack {
                Calendarview()

                menu
            }
            .navigationBarTitle("\(preference.language(Homedomain.calendar.rawValue))", displayMode: .large)
        }
    }
}

public var PAGEDDOMAIN_KEY = "pageddomain"

class Pageddomain: ObservableObject {
    @Published var pageddomain: Homedomain

    init() {
        pageddomain = .workouts

        if let _cache = AppDatabase.shared.queryappcache(PAGEDDOMAIN_KEY) {
            pageddomain = Homedomain(rawValue: _cache.cachevalue) ?? .workouts
        }
    }

    let lock = NSLock()

    func focus(_ page: Homedomain) {
        /*
         lock.lock()
         defer {
             lock.unlock()
         }
         */

        pageddomain = page

        DispatchQueue(label: "homefocused", qos: .background).async {
            var appcache = Appcache(cachekey: PAGEDDOMAIN_KEY, cachevalue: page.rawValue)
            try! AppDatabase.shared.saveappcache(&appcache)
        }
    }
}

extension Pageddomain {
    static var shared = Pageddomain()
}

/*

 var tab: some View {
     VStack {
         switch pageddomain.pageddomain {
         case .workouts:
             workouts

         case .settings:
             settings

         case .calendar:
             SPACE
         case .library:
             library
         }
     }
 }

 */
