//
//  ConfigsettingPage.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/20.
//

import SwiftUI
import UIKit

struct Settingsbetaview_Previews: PreviewProvider {
    static var previews: some View {
        let config = prepareconfig()

        DisplayedView {
            Settingsbetaview()
        }
    }
}

func prepareconfig() -> Config {
    try! AppDatabase.shared.deleteConfig()
    var config = Config._default()

    try! AppDatabase.shared.saveConfig(&config)
    return config
}

struct DataView: View {
    var body: some View {
        SettingPanel(name: "data") {
            VStack(spacing: 0) {
                recoverlabel
            }
        }
    }

    var recoverlabel: some View {
        NavigationLink {
            NavigationLazyView(
                Recoverview()
            )
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        } label: {
            Recoverlabel()
        }
        .isDetailLink(false)
    }
}

struct SupportView: View {
    @StateObject var shwocontactmail = Viewopenswitch()
    @StateObject var showreportbugmail = Viewopenswitch()

    @State private var contactemail =
        SupportEmail(
            toAddress: "bbetterchris@gmail.com",
            subject: "\(PreferenceDefinition.shared.language("wantanewfeature"))",
            messageHeader: "\(PreferenceDefinition.shared.language("wantanewfeature"))",
            body: "\(PreferenceDefinition.shared.language("wantanewfeaturedesc", firstletteruppercase: false))"
        )

    @State private var bugemail =
        SupportEmail(
            toAddress: "bbetterchris@gmail.com",
            subject: "\(PreferenceDefinition.shared.language("bugreport"))",
            messageHeader: "\(PreferenceDefinition.shared.language("bugreport"))",
            body: "\(PreferenceDefinition.shared.language("bugreportdesc", firstletteruppercase: false))"
        )

    var body: some View {
        SettingPanel(name: "support") {
            VStack(spacing: 0) {
                review
                LIGHT_LOCAL_DIVIDER

                contactus
                LIGHT_LOCAL_DIVIDER

                bugreport
            }
        }
    }
}

extension SupportView {
    var review: some View {
        Listitemlabel(
            img: Image("star"),
            keyortitle: "rateappinappstore"
        ) {
            Image(systemName: "chevron.right")
                .foregroundColor(NORMAL_GRAY_COLOR)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            ReviewHandler.requestReviewManually()
        }
    }

    var contactus: some View {
        Listitemlabel(
            img: Image("idea"),
            keyortitle: "wantanewfeature"
        ) {
            Image(systemName: "chevron.right")
                .foregroundColor(NORMAL_GRAY_COLOR)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            contactemail.send()
        }
    }

    var bugreport: some View {
        Listitemlabel(
            img: Image("paywarn"),
            keyortitle: "bugreport"
        ) {
            Image(systemName: "chevron.right")
                .foregroundColor(NORMAL_GRAY_COLOR)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            bugemail.send()
        }
    }
}

class Preference: ObservableObject {
    @Published var weightunit: Weightunit = .kg
    @Published var userestimer: Bool = true
    @Published var restinterval: Int = 60
    //
    var notifysoundeffect: String = ""

    init() {
        if let _c = AppDatabase.shared.queryConfig() {
            weightunit = _c.weightunit
            userestimer = _c.useresttimer ?? true
            restinterval = _c.restinterval ?? 60
            notifysoundeffect = _c.notifysoundeffect ?? ""
        }
    }

    func save() {
        DispatchQueue(label: "preference", qos: .background).async {
            if var _c = AppDatabase.shared.queryConfig() {
                _c.weightunit = self.weightunit
                _c.useresttimer = self.userestimer
                _c.restinterval = self.restinterval
                _c.notifysoundeffect = self.notifysoundeffect

                try! AppDatabase.shared.saveConfig(&_c)
            }
        }
    }
}

struct PreferenceView: View {
    @EnvironmentObject var preference: PreferenceDefinition

    /*
     * variables
     */
    //@StateObject var model = Preference()
    @ObservedObject var model = Preference()
    @StateObject var restopenswitch = Viewopenswitch()

    var body: some View {
        SettingPanel(name: "preference") {
            VStack(spacing: 0) {
                weightunit

                LIGHT_LOCAL_DIVIDER

                resttimer
            }
        }
    }
}

extension PreferenceView {
    var weightunit: some View {
        NavigationLink {
            Settingdetailview(
                name: "weightunit",
                selectedoption: model.weightunit.rawValue,
                options: Array(
                    Weightunit.allCases.map({ $0.rawValue })
                )
            ) { option in

                if let wu = Weightunit(rawValue: option) {
                    model.weightunit = wu
                    model.save()
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

        } label: {
            Listitemlabel(
                imgsize: 18,
                keyortitle: "weightunit",
                value: model.weightunit.name) {
                }
        }
    }

    var resttimer: some View {
        NavigationLink(isActive: $restopenswitch.value.onChange({ newvalue in
            if !newvalue {
                model.save()
            }
        })) {
            Settingresttimerview(name: "resttimer")
                .environmentObject(model)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } label: {
            Listitemlabel(
                imgsize: 18,
                keyortitle: "resttimer",
                value: displaytime(model.restinterval)) {
                }
        }
    }
    
    func displaytime(_ time: Int) -> String {
        if time < 0 {
            return preference.language("none")
        } else {
            return "\(String(format: "%02d", time / 60)):\(String(format: "%02d", time % 60))"
        }
    }
}

class General: ObservableObject {
    @Published var theme: Themecolor = .blue
    @Published var language: Language = .english

    @Published var usesystemappearence: Bool = true {
        didSet {
            decideschemecolor(usesystem: usesystemappearence)
        }
    }

    @Published var appearance: Appearence = .light
    @Published var isdarkmode = false {
        didSet {
            decideschemecolor(usesystem: usesystemappearence, appearance: isdarkmode ? .dark : .light)
        }
    }

    init() {
        if let _c = AppDatabase.shared.queryConfig() {
            usesystemappearence = _c.usesystemappearence ?? true
            appearance = _c.appearence
            theme = _c.themecolor
            language = _c.preference

            isdarkmode = appearance == .dark
        }
    }

    func save() {
        DispatchQueue(label: "general", qos: .background).async {
            if var _c = AppDatabase.shared.queryConfig() {
                _c.usesystemappearence = self.usesystemappearence
                _c.appearence = self.appearance
                _c.themecolor = self.theme
                _c.preference = self.language

                try! AppDatabase.shared.saveConfig(&_c)
            }
        }
    }
}

struct Generalview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    /*
     * preference related
     */
    @StateObject var model = General()

    var body: some View {
        SettingPanel(name: "general") {
            VStack(spacing: 0) {
                appearance
                LIGHT_LOCAL_DIVIDER

                themecolor
                LIGHT_LOCAL_DIVIDER

                language
            }
        }
    }

    var language: some View {
        NavigationLink {
            Settingdetailview(
                name: "language",
                selectedoption: model.language.rawValue,
                options: [Language.english.rawValue, Language.simpledchinese.rawValue]) { l in

                    if let _l = Language(rawValue: l) {
                        model.language = _l
                        model.save()
                    }
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } label: {
            Listitemlabel(
                imgsize: 16,
                keyortitle: "language",
                value: model.language.name
            ) {
            }
        }
    }

    @StateObject var openswitch = Viewopenswitch()

    var appearance: some View {
        NavigationLink(isActive: $openswitch.value) {
            Settingappearanceview(name: "appearance")
                .environmentObject(model)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } label: {
            Listitemlabel(
                keyortitle: "appearance"
            ) {
                HStack(spacing: 5) {
                    LocaleText(
                        model.usesystemappearence ? "system" :
                            model.appearance.rawValue
                    )

                    Image(systemName: "chevron.right")
                        .foregroundColor(NORMAL_GRAY_COLOR)
                }
            }
        }
    }

    var themecolor: some View {
        NavigationLink {
            Settingdetailview(
                name: "theme",
                selectedoption: model.theme.rawValue,
                options: Array(
                    Themecolor.allCases.map({ $0.rawValue })
                ),
                convert: {
                    option in
                    if let _tc = Themecolor(rawValue: option) {
                        return AnyView(Themecolorlabel(themecolor: _tc))
                    }

                    return AnyView(EmptyView())
                }) { option in

                    if let _tc = Themecolor(rawValue: option) {
                        model.theme = _tc
                        model.save()
                    }
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)

        } label: {
            Listitemlabel(
                keyortitle: "theme") {
                    HStack(spacing: 8) {
                        Themecolorlabel(themecolor: model.theme)

                        Image(systemName: "chevron.right")
                            .foregroundColor(NORMAL_GRAY_COLOR)
                    }
                }
        }
    }
}

struct SettingPanel<SettingsView>: View where SettingsView: View {
    let name: String?
    let content: () -> SettingsView

    init(name: String? = nil, @ViewBuilder content: @escaping () -> SettingsView) {
        self.name = name
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let _name = name {
                HStack {
                    LocaleText(_name)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                        .foregroundColor(NORMAL_BUTTON_COLOR)

                    SPACE
                }
                .padding(.horizontal)
            }

            VStack {
                self.content()
            }
            .background(NORMAL_BG_CARD_COLOR)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 20, x: 0, y: 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical)
    }
}

struct Settingsbetaview: View {
    @EnvironmentObject var preference: PreferenceDefinition

    /*
     * variables
     */
    @StateObject var showheader = Viewopenswitch()

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    permitpluspanel.padding(.horizontal, 10)

                    content
                }

                SPACE
            }
        }
    }

    var content: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            Generalview()

            PreferenceView()

            SupportView()

            DataView()

            Copyright()
        }
    }
}

extension Settingsbetaview {
    var upheader: some View {
        ZStack {
            if showheader.value {
                HStack {
                    SPACE

                    LocaleText("settings")
                        .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                        .foregroundColor(NORMAL_LIGHTER_COLOR)

                    SPACE
                }
                .padding(.horizontal, 10)
                .frame(height: MIN_UP_TAB_HEIGHT)
                .background(NORMAL_UPTAB_BACKGROUND_COLOR)
            }
        }
    }

    var hiddenbar: some View {
        Text(" ")
            .frame(width: UIScreen.width, height: 10)
            .contentShape(Rectangle())
            .onAppear {
                self.showheader.value = false
            }
            .onDisappear {
                self.showheader.value = true
            }
    }

    var scrollheader: some View {
        HStack {
            LocaleText(
                "settings",
                usefirstuppercase: false,
                alignment: .center,
                usescale: false
            )
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .font(.system(size: DEFINE_FONT_BIGGEST_SIZE + 8).weight(.heavy))

            SPACE
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
    }

    var permitpluspanel: some View {
        Permitpluspanel()
    }
}
