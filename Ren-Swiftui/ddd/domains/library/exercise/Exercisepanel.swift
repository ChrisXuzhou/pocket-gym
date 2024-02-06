//
//  Exercisepanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/4.
//

import AVKit
import SwiftUI

struct Exercisepanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Librarybetaview(
                showbackbutton: true,
                usage: Libraryusage(usage: .forselect)
            )
            .navigationBarHidden(true)
        }

        /*
         DisplayedView {
             Librarybetaview(showbackbutton: false)
                 .navigationBarHidden(true)
         }

         DisplayedView {
             Librarybetaview(present: .constant(false), showbackbutton: false, usage: Libraryusage(usage: .forselect))
                 .navigationBarHidden(true)
         }

         DisplayedView {
             Librarybetaview(present: .constant(false), showbackbutton: false)
                 .navigationBarHidden(true)
         }
         */

        /*
         let _exercise = Newdisplayedexercise(AppDatabase.shared.queryNewexercisedefs("curl", equipmentid: "dumbbell").first!)

         DisplayedView {
             ScrollView(showsIndicators: false) {
                 HStack {
                     SPACE
                     Exercisepanel(exercise: _exercise)
                     Exercisepanel(exercise: _exercise)
                     Exercisepanel(exercise: _exercise)
                 }
                 .padding(.horizontal, 10)
             }
             .environmentObject(Libraryusage(usage: .forselect))
         }
         */
    }
}

let DEFAULT_VIDEO_RATE: Float = 1.5

let RIGHT_GRID_COUNT: CGFloat = 3
let RIGHT_GRID_SPACING: CGFloat = 10

let RIGHT_GRID_WIDTH: CGFloat = (UIScreen.width - RIGHT_GRID_SPACING * 2 - 20) / RIGHT_GRID_COUNT
let RIGHT_GRID_HEIGHT: CGFloat = RIGHT_GRID_WIDTH * 2 / 3 + 20

let GRID_DESC_CN_HEIGHT: CGFloat = 40
let GRID_DESC_EN_HEIGHT: CGFloat = 50

let GRID_DOWN_NAVI_BUTTON: CGFloat = 30

class Videosettings: ObservableObject {
    @Published var play: Bool = false
}

struct Exercisepanel: View {
    @Environment(\.colorScheme) var colorscheme
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var libraryusage: Libraryusage

    @ObservedObject var exercise: Newdisplayedexercise
    @StateObject var videosettings = Videosettings()

    /*
     * variables
     */
    var fontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE
    var fontcolor: Color = NORMAL_LIGHTER_COLOR

    @StateObject var linkswitch = Viewopenswitch()

    var body: some View {
        ZStack {
            let height = decidepanelheight

            ZStack {
                NavigationLink(isActive: $linkswitch.value) {
                    NavigationLazyView(
                        ExerciseView(exercise: exercise)
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                    )
                } label: {
                    EmptyView()
                }
                .hidden()

                VStack {
                    imgprvideo
                        .padding(.top)

                    SPACE
                }

                if libraryusage.usage == .forview {
                    Button {
                        linkswitch.value = true
                    } label: {
                        _body
                    }

                } else if libraryusage.usage == .forselect {
                    _body
                        .contentShape(Rectangle())
                        .onTapGesture {
                            endtextediting()

                            libraryusage.libraryaction?.aexerciseseleted(exercise)

                            libraryusage.objectWillChange.send()
                        }

                    VStack {
                        SPACE

                        detailbutton
                            .padding(.horizontal, 5)
                            .padding(.bottom, 3)
                    }
                }
            }
            .frame(width: RIGHT_GRID_WIDTH, height: height + RIGHT_GRID_HEIGHT)
            .background(NORMAL_BG_VIDEO_COLOR)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            // .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 5)
        }
    }

    var _body: some View {
        ZStack {
            /*

                 if colorscheme == .dark {
                     Color.black.opacity(0.3).ignoresSafeArea()
                 }
             */

            panelcolor

            VStack(spacing: 0) {
                SPACE

                description
                    .frame(height: decidepanelheight)
            }
        }
    }
}

extension Exercisepanel {
    var detailbutton: some View {
        VStack {
            Button {
                linkswitch.value = true
            } label: {
                HStack {
                    SPACE
                    LocaleText("details", uppercase: false)
                    SPACE
                }
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .frame(height: 25)
                .background(NORMAL_BG_GRAY_COLOR)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: NORMAL_GRAY_COLOR, radius: 8)
            }

            SPACE
        }
        .frame(height: GRID_DOWN_NAVI_BUTTON)
    }

    var decidepanelheight: CGFloat {
        var height = (preference.oflanguage == .english ? GRID_DESC_EN_HEIGHT : GRID_DESC_CN_HEIGHT)

        if libraryusage.usage == .forselect {
            height += GRID_DOWN_NAVI_BUTTON
        }

        return height
    }

    var imgprvideo: some View {
        DisplayedexerciseVideo(exercise: exercise,
                               width: RIGHT_GRID_WIDTH - 10, videosettings: videosettings)
    }

    var description: some View {
        VStack(spacing: 0) {
            SPACE

            HStack(spacing: 0) {
                SPACE

                LocaleText(exercise.realname, linelimit: 5, alignment: .center, linespacing: 2)
                    .font(.system(size: fontsize))
                    .foregroundColor(fontcolor)

                SPACE
            }

            SPACE

            if libraryusage.usage == .forselect {
                SPACE.frame(height: GRID_DOWN_NAVI_BUTTON)
            }
        }
        .padding(.horizontal, 5)
        .background(
            ZStack {
                if colorscheme == .dark {
                    NORMAL_BG_CARD_COLOR.opacity(0.7)
                }

                // panelcolor
            }
        )
    }

    var panelcolor: Color {
        if libraryusage.usage == .forview {
            return Color.clear
        } else {
            if let _action = libraryusage.libraryaction {
                if _action.isselected(exercise) {
                    return preference.theme.opacity(0.3)
                }
            }

            return Color.clear
        }
    }

    var detailnavibutton: some View {
        Button {
        } label: {
            HStack {
                SPACE
                LocaleText("details")
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                    .foregroundColor(NORMAL_BUTTON_COLOR)
                SPACE
            }
            .frame(height: 25)
            .background(NORMAL_BG_GRAY_COLOR)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct DisplayedexerciseVideo: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var videosettings: Videosettings

    init(exercise: Newdisplayedexercise, width: CGFloat, videosettings: Videosettings? = nil) {
        self.exercise = exercise
        self.width = width
        self.videosettings = videosettings ?? Videosettings()

        _img = .init(initialValue: getSafeImage(named: exercise.exercise.imgname))
    }

    var exercise: Newdisplayedexercise

    var width: CGFloat = RIGHT_GRID_WIDTH
    var height: CGFloat {
        width * (2 / 3)
    }

    /*
     * function variables
     */
    @State var img: Image?

    var body: some View {
        ZStack {
            imgorvideolayer
        }
    }
}

extension DisplayedexerciseVideo {
    /*
     * mp4 not used anymore: for performance reason.
     */
    var imgorvideolayer: some View {
        ZStack {
            displayedasvideo
        }
        .frame(width: width, height: height)
        .background(NORMAL_BG_VIDEO_COLOR)
    }

    var displayedasvideo: some View {
        HStack {
            if let v = img {
                v.resizable()
                    .aspectRatio(contentMode: .fit)

            } else {
                Resourcenotfound()
            }

            /*
             if let v = img {
                 if videosettings.play {
                     VideoView(v: exercise.exercise.imgname, rate: 1.5)
                 } else {
                     v.resizable()
                         .aspectRatio(contentMode: .fit)
                 }

             } else {
                 Resourcenotfound()
             }
             */
        }
        .onAppear {
            /*
             if let url = Bundle.main.url(forResource: exercise.exercise.imgname, withExtension: "mp4") {
                 AVAsset(url: url).generateThumbnail {
                     image in
                     DispatchQueue.main.async {
                         guard let image = image else { return }

                         self.img = Image(uiImage: image)
                     }
                 }
             }
             */
        }
    }
}

/*

 var displayedasimg: some View {
     ZStack {
         if let img = retrieveImage(forKey: exercise.exercise.imgname, inStorageType: .fileSystem) {
             Image(uiImage: img)
                 .resizable().aspectRatio(contentMode: .fit)
         }
     }
 }
 */
