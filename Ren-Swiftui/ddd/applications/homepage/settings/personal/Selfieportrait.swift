//
//  SelfiePortrait.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/18.
//

import SwiftUI

struct Selfieportrait_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            SelfieLabel()
        }
        .environmentObject(Personalsettingsmodel())

    }
}

class NickEditor: Texteditor {
    func save(_ newvalue: String?) {
        if var _selfie = selfie {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                _selfie.nick = newvalue ?? ""
                try! AppDatabase.shared.saveSelfie(&_selfie)
            }
        }
    }

    var selfie: Selfie?

    init(_ selfie: Selfie?) {
        self.selfie = selfie
    }
}

class PhoneEditor: Texteditor {
    func save(_ newvalue: String?) {
        if var _selfie = selfie {
            _selfie.phone = newvalue ?? ""
            try! AppDatabase.shared.saveSelfie(&_selfie)
        }
    }

    var selfie: Selfie?

    init(_ selfie: Selfie?) {
        self.selfie = selfie
    }
}

struct SelfieLabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Personalsettingsmodel

    var gender: Gender {
        model.selfie.gender
    }

    var nick: String {
        model.selfie.nick
    }

    var phone: String {
        model.selfie.phone
    }

    @State var nickinput = false
    var nickview: some View {
        HStack {
            Text(nick.isEmpty ? preference.language("appname", firstletteruppercase: false) : nick)
                .tracking(1)
                .font(.system(size: DEFINE_FONT_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            nickinput.toggle()
        })
        .fullScreenCover(isPresented: $nickinput) {
            TextfieldditorView(value: nick,
                               title: preference.language("username"),
                               editor: NickEditor(model.selfie)
            )
        }
    }

    @State var phoneinput = false
    var phoneview: some View {
        HStack {
            HStack(spacing: 0) {
                Image(systemName: "iphone.circle")
                    .padding(.trailing, 1)
                    .font(.system(size: 10))

                Text(phone.replacingOccurrences(of: " ", with: ""))

                Spacer()
            }
            .font(.system(size: DEFINE_FONT_SIZE))
            .foregroundColor(Color(.systemGray))
        }
        .onTapGesture(perform: {
            phoneinput.toggle()
        })
        .fullScreenCover(isPresented: $phoneinput) {
            TextfieldditorView(textfield: .phone,
                               value: phone,
                               title: preference.language(LANGUAGE_PHONE),
                               editor: PhoneEditor(model.selfie))
        }
    }

    var body: some View {
        HStack(spacing: 2) {
            Selfieportrait(gender: gender)

            VStack {
                SPACE
                nickview.padding(.leading, 5)
            }
            .frame(height: 40)

            SPACE
        }
    }
}

struct Selfieportrait: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var gender: Gender?

    var imgsize: CGFloat = 60

    var portraitImg: String {
        if let _gender = gender {
            switch _gender {
            case .male:
                return "malegender"
            case .female:
                return "femalegender"
            case .other:
                return "logo"
            }
        } else {
            return "logo"
        }
    }

    var body: some View {
        Image(portraitImg)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .clipShape(Circle())
            .padding(5)
            .overlay(
                Circle()
                    .stroke(
                        preference.themesecondarycolor,
                        lineWidth: 2
                    )
            )
            .padding(3)
            .background(
                Circle()
                    .foregroundColor(NORMAL_BG_COLOR)
            )
            .contentShape(Rectangle())
    }
}
