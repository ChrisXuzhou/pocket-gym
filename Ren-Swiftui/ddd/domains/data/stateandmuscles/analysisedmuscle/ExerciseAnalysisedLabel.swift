import AudioToolbox
import AVKit
import SwiftUI

struct analysisedexerciseLabel_Previews: PreviewProvider {
    static var previews: some View {
        let mockPrimary = Analysisedexercise(
            exerciseid: 19009,
            workoutid: -1, batchid: -1,
            workday: Date(),
            volume: 10000,
            onerm: 100,
            sets: 3,
            minrepeats: 10,
            minweight: 50,
            maxweight: 100
        )

        DisplayedView {
            analysisedexerciseLabel(analysised: mockPrimary)
        }
    }
}

struct analysisedexerciseLabelValue: View {
    var description: String
    var value: Double
    var delta: Double

    var deltaLabel: some View {
        HStack(spacing: 1) {
            Image("upArrow")
                .renderingMode(.template)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(
                    delta > 0 ? NORMAL_GREEN_COLOR : NORMAL_RED_COLOR
                )
                .rotationEffect(.degrees(delta < 0 ? 180 : 0))
                .offset(y: 2)

            Text(String(format: "%.1f", delta))
                .font(.system(size: 15))
                .foregroundColor(.primary.opacity(0.7))
        }
        .padding(.horizontal, 5)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(.systemGray5).opacity(0.7))
        )
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 5) {
            VStack(alignment: .leading) {
                Text(description)
                    .font(.system(size: 18).bold())
                Text(String(format: "%.1f", value))
            }
            deltaLabel
        }
        .font(.system(size: 14))
        .foregroundColor(.primary.opacity(0.7))
    }
}

struct analysisedexerciseLabel: View {
    var exercise: Newdisplayedexercise?
    var analysised: Analysisedexercise

    init(analysised: Analysisedexercise) {
        self.analysised = analysised
        exercise = analysised.exercise
    }

    @State var video: Image?
    @State var detail = false

    let displayWidth: CGFloat = 90
    let displayHeight: CGFloat = 60

    var display: some View {
        HStack {
            if let v = video {
                v.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: displayWidth, height: displayHeight, alignment: .center)
                    .clipped()
            }
        }
        .onAppear(perform: {
            if let imgname = exercise?.exercise.imgname {
                if let url = Bundle.main.url(forResource: imgname, withExtension: "mp4") {
                    AVAsset(url: url).generateThumbnail {
                        image in
                        DispatchQueue.main.async {
                            guard let image = image else { return }
                            self.video = Image(uiImage: image)
                        }
                    }
                }
            }
        })
        .frame(width: displayWidth, height: displayHeight)
        .padding(.vertical, 5)
        .overlay(
            VStack {
                if let _exercise = exercise {
                    SPACE
                    HStack {
                        SPACE
                        // Musclelink(muscle: _exercise._primarymuscledef, showtext: false)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        .pink.opacity(0.1)
                    )
            )
        )
    }

    var name: some View {
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            if let _exercise = exercise {
                Text(_exercise.realname)
                Text("(kg)")
                    .font(.system(size: 16))
            }
        }
        .font(.system(size: 17))
        .foregroundColor(Color(.systemGray2))
    }

    var indicators: some View {
        VStack(alignment: .leading) {
            analysisedexerciseLabelValue(
                description: "1RM",
                value: analysised.onerm, delta: 15
            )
        }
    }

    var exerciseView: some View {
        VStack {
            /*
             if let _exercise = exercise {
                 analysisedexerciseView(exercise: _exercise)
             }
             
             */
        }
    }

    let height: CGFloat = 100

    var body: some View {
        HStack(spacing: 5) {
            display
            VStack(alignment: .leading, spacing: 0) {
                name
                indicators
            }
            .padding(.horizontal)
            Spacer()

            Image(systemName: "chevron.right")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color(.systemGray6))
                )
        }
        .padding(.horizontal)
        .frame(height: height)
        .onTapGesture(perform: {
            detail.toggle()
        })
        .padding(.horizontal, 10)
        .fullScreenCover(isPresented: $detail) {
            exerciseView
        }
    }
}
