//
//  Exerciselabelvideo.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/16.
//

import AudioToolbox
import AVKit
import SwiftUI

struct Exerciselabelvideo: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @State var videostats: Videostats = .video

    var exercise: Newdisplayedexercise
    var showlink = false
    var showexercisedetailink = false

    var lablewidth: CGFloat = LABEL_VIDEO_WIDTH
    var lableheight: CGFloat = LABEL_VIDEO_HEIGHT

    /*
     * varibales
     */
    @StateObject var linkswitch = Viewopenswitch()
    
    var body: some View {
        ZStack {
            if showlink {
                NavigationLink(isActive: $linkswitch.value) {
                    navilink
                } label: {
                    EmptyView()
                }
                .hidden()
            }

            displayedvideolayer
                .contentShape(Rectangle())
                .onTapGesture {
                    linkswitch.value = true
                }
        }
        .frame(width: lablewidth)
    }
}

extension Exerciselabelvideo {
    var navilink: some View {
        NavigationLazyView(
            ExerciseView(exercise: exercise)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        )
    }

    var displayuserimg: some View {
        VStack {
            if let _uiimage = retrieveImage(forKey: exercise.exercise.imgname, inStorageType: .fileSystem) {
                Image(uiImage: _uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }

    var displayedvideolayer: some View {
        VStack {
            let img = exercise.exercise.imgname

            if exercise.exercise.source == .system {
                VideoView(v: img, rate: 1.5)
                    .frame(width: lablewidth, height: lableheight)
            } else {
                displayuserimg
            }
        }
        .frame(width: lablewidth, height: lableheight)
        .background(NORMAL_BG_VIDEO_COLOR)
        .overlay(preference.theme.opacity(0.1))
        .clipShape(
            RoundedRectangle(cornerRadius: EXERCISE_BACKGROUD_RADIUS)
        )
        .animationsDisabled()
    }
}

extension AVAsset {
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
