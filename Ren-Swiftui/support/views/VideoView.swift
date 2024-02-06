import AVKit
import SwiftUI

struct VideoLabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                VideoView(v: "barbell_shrug")

                VideoView(v: "notfound")
                    .frame(width: 60)
            }
        }
    }
}

struct VideoView: View {
    private var queuePlayer: AVQueuePlayer?
    private var playerLooper: AVPlayerLooper?

    var filename: String
    var rate: Float

    init(v filename: String, rate: Float = 1.0) {
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)

        self.filename = filename
        self.rate = rate

        let rawUrl: URL? = Bundle.main.url(forResource: filename, withExtension: "mp4")

        guard let videoUrl = rawUrl else {
            queuePlayer = nil
            playerLooper = nil
            return
        }

        let asset = AVAsset(url: videoUrl)
        let playerItem = AVPlayerItem(asset: asset)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)

        queuePlayer?.isMuted = true
        queuePlayer?.play()
        queuePlayer?.rate = rate

    }

    var body: some View {
        HStack {
            if queuePlayer != nil {
                PlayerView(player: queuePlayer!)
                    .onAppear {
                        queuePlayer?.play()
                        queuePlayer?.rate = rate
                    }
            } else {
                Resourcenotfound()
            }
        }
    }
}

class PlayerUIView: UIView {
    // MARK: Class Property

    let playerLayer = AVPlayerLayer()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(player: AVPlayer) {
        super.init(frame: .zero)
        playerSetup(player: player)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Life-Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    // MARK: Class Methods

    private func playerSetup(player: AVPlayer) {
        playerLayer.player = player
        player.actionAtItemEnd = .none
        layer.addSublayer(playerLayer)
        playerLayer.backgroundColor = UIColor.clear.cgColor // <--- Set color here
    }
}

struct PlayerView: UIViewRepresentable {
    var player: AVQueuePlayer

    func makeUIView(context: Context) -> PlayerUIView {
        return PlayerUIView(player: player)
    }

    func updateUIView(_ uiView: PlayerUIView, context: UIViewRepresentableContext<PlayerView>) {
        uiView.playerLayer.player = player
    }
}

struct Resourcenotfound: View {
    
    var body: some View {
        Image("gym")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(15)
            .background(
                Circle()
                    .stroke(NORMAL_GRAY_COLOR, lineWidth: 3)
            )
            .foregroundColor(NORMAL_GRAY_COLOR)
            .padding(3)
    }
}
