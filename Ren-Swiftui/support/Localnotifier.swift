//
//  Localnotifier.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/16.
//

import Foundation
import SwiftUI

class Localnotifier: ObservableObject {
    var notifications = [Notification]()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                log("[info] notifications permitted")
            } else {
                log("[alert] notifications not permitted")
            }
        }
    }

    func sendNotification(title: String, subtitle: String?, body: String, launchIn: Double) {
        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        
        content.sound = UNNotificationSound.default
        content.body = body

        let imageName = "logo"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: launchIn, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)

        log("notification sent ...")
    }
}

