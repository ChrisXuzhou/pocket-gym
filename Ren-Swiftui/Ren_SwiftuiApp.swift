
import BackgroundTasks
import StoreHelper
import SwiftUI
import Updates

@main
struct Ren_SwiftuiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 1. app notify auth
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if granted == true && error == nil {
                            log("[info] notifications permitted")
                        } else {
                            log("[alert] notifications not permitted")
                        }
                    }

                    // 2. decide color
                    Task {
                        decideschemecolor()
                    }

                    // 3. recover log
                    Task {
                        StoreHelper.shared.donothing()
                    }

                    Task {
                        Libraryexercisemodel.shared.donothing()
                    }

                    // 4. request review
                    ReviewHandler.requestReview()
                }
        }
    }
}

extension Permit {
    static var shared = Permit()
}
