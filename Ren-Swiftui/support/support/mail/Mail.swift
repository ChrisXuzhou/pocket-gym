

import SwiftUI
import UIKit

struct SupportEmail {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var data: Data?
    var body: String

    /*
     {"""
         Application Name: \(Bundle.main.displayName)
         iOS: \(UIDevice.current.systemVersion)
         Device Model: \(UIDevice.current.modelName)
         Appp Version: \(Bundle.main.appVersion)
         App Build: \(Bundle.main.appBuild)
         \(messageHeader)
     --------------------------------------
     """
     }
     */

    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                log("""
                    This device does not support email
                    \(body)
                    """
                )
            }
        }
    }

    func send() {
        // Build the URL from its components
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = toAddress
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body),
        ]

        guard let url = components.url else {
            NSLog("Failed to create mailto URL")
            return
        }

        UIApplication.shared.open(url) { success in
            // handle success or failure

            if success {
                log("Email sent")
            } else {
                log("Email sent failed.")
            }
        }
    }
}
