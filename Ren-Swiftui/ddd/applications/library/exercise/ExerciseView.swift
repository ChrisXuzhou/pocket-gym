//
//  ExerciseView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/17.
//

import SwiftUI

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ExerciseView(exercise: prepareexercise())
        }
    }
}

func prepareexercise() -> Newdisplayedexercise {
    Libraryexercisemodel.shared.all.first!
}

let EXERCISE_VIEW_PAGED_TO_KEY = "exerciseviewpagedto"

enum Exerciseviewpagedto: String, CaseIterable {
    case details, reviews

    var index: Int {
        switch self {
        case .details:
            return 0
        case .reviews:
            return 1
        }
    }
}

class Exerciseviewpagedtomodel: ObservableObject {
    @Published var pagedto: Exerciseviewpagedto

    init(_ defaultpage: Exerciseviewpagedto? = nil) {
        if let _defaultpage = defaultpage {
            pagedto = _defaultpage
        } else {
            pagedto = .details

            if let _cache = AppDatabase.shared.queryappcache(EXERCISE_VIEW_PAGED_TO_KEY) {
                pagedto = Exerciseviewpagedto(rawValue: _cache.cachevalue) ?? .details
            }
        }
    }
}

struct ExerciseView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var presentmode

    @ObservedObject var exercise: Newdisplayedexercise
    @StateObject var model: Exerciseviewmodel

    /*
     * variables
     */
    @StateObject var pagedmodel: Exerciseviewpagedtomodel
    @StateObject var moreedit = Editviewmore()
    @StateObject var showediting = Viewopenswitch()

    init(exercise: Newdisplayedexercise,
         defaultpage: Exerciseviewpagedto? = nil) {
        /*
         *
         */
        self.exercise = exercise // StateObject(wrappedValue: )
        _model = StateObject(wrappedValue: Exerciseviewmodel(exercise))
        _pagedmodel = StateObject(wrappedValue: Exerciseviewpagedtomodel(defaultpage))
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                upheader

                pagedmenu

                ScrollView(.vertical, showsIndicators: false) {
                    videopanel

                    switch pagedmodel.pagedto {
                    case .details:
                        ExercisedetailView(exercise: exercise)
                    case .reviews:
                        Reviewworkoutsview(exercisedef: exercise)
                    }
                }
            }
        }
    }
}

extension ExerciseView {
    var buttonspanel: some View {
        HStack(spacing: 20) {
            Button {
                showediting.value = true
            } label: {
                Pencile(imgsize: 20)
                    .foregroundColor(NORMAL_BUTTON_COLOR)
            }

            if exercise.exercise.source == .user {
                Button {
                    moreedit.value = true
                } label: {
                    Moreshape(imgsize: 20, color: NORMAL_BUTTON_COLOR)
                }
            }
        }
        .confirmationDialog("", isPresented: $moreedit.value) {
            Button("\(preference.language("delete"))", role: .destructive) {
                presentmode.wrappedValue.dismiss()

                Libraryexercisemodel.shared.deleteexercise(exercise)
            }
        }
        .fullScreenCover(isPresented: $showediting.value) {
            Exercisevieweditor(exercise)
        }
    }

    var upheader: some View {
        HStack {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }
            .padding(.trailing, 10)

            SPACE

            LocaleText(exercise.realname, usefirstuppercase: true, linelimit: 2)
                .font(.system(size: UP_HEADER_SUBTITLE_FONT_SIZE).bold())
                .padding(0)

            SPACE

            buttonspanel
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(
            NORMAL_BG_COLOR.ignoresSafeArea()
        )
    }
}

extension ExerciseView {
    var pagedmenu: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(Exerciseviewpagedto.allCases, id: \.self) {
                    type in

                    ExerciseviewpagedtoIcon(
                        description: type.rawValue,
                        selected: pagedmodel.pagedto == type
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        pagedmodel.pagedto = type

                        DispatchQueue.global().async {
                            var appcache = Appcache(cachekey: EXERCISE_VIEW_PAGED_TO_KEY, cachevalue: type.rawValue)
                            try! AppDatabase.shared.saveappcache(&appcache)
                        }
                    }
                }
            }
            .frame(width: UIScreen.width)

            ZStack(alignment: .bottom) {
                // LOCAL_DIVIDER

                Rectangle()
                    .frame(width: UIScreen.width / 2)
                    .position(x: BASE_OFFSET_X + CGFloat(UIScreen.width / 2) * CGFloat(pagedmodel.pagedto.index), y: 0)
                    .frame(height: 1)
                    .foregroundColor(preference.theme)
            }
            .frame(width: UIScreen.width)
        }
    }

    var videopanel: some View {
        VStack {
            let width = UIScreen.width
            let height = UIScreen.width * (2 / 3)

            ZStack {
                NORMAL_BG_VIDEO_COLOR

                model
                    .video
                    .frame(width: width, height: height)
                    .id(exercise.exercise.ident)
            }
            .frame(width: width, height: height)
        }
    }
}

let BASE_OFFSET_X: CGFloat = UIScreen.width / 4

struct ExerciseviewpagedtoIcon: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var description: String
    var selected: Bool

    var body: some View {
        VStack(spacing: 0) {
            SPACE

            LocaleText(description, usefirstuppercase: false)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(selected ? preference.theme : NORMAL_LIGHT_BUTTON_COLOR)

            SPACE
        }
        .frame(width: UIScreen.width / CGFloat(Exerciseviewpagedto.allCases.count),
               height: 45
        )
    }
}
