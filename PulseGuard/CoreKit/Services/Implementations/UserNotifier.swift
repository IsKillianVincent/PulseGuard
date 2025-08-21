//
//  UserNotifier.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation
import UserNotifications

final class UserNotifier: NSObject, Notifying, UNUserNotificationCenterDelegate {
    static let shared = UserNotifier()

    func requestAuth(_ completion: ((Bool) -> Void)? = nil) {
        let c = UNUserNotificationCenter.current()
        c.delegate = self
        c.getNotificationSettings { s in
            if s.authorizationStatus == .notDetermined {
                c.requestAuthorization(options: [.alert, .sound, .badge]) { g, _ in completion?(g) }
            } else {
                completion?(s.authorizationStatus == .authorized || s.authorizationStatus == .provisional)
            }
        }
    }

    func notify(_ title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        )
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
