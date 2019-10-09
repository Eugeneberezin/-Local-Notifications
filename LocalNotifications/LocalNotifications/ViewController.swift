//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Eugene Berezin on 10/8/19.
//  Copyright © 2019 Eugene Berezin. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound, .providesAppNotificationSettings, .announcement, .criticalAlert]) { granted, error in
            if granted {
                print("Yay")
            } else {
                print("D'oh!")
            }
        }
        
        
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Notification testing"
        content.body = "You're an awesome iOS dev. You just created a notification"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 37
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Open the app", options: [.foreground, .destructive])
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [.allowAnnouncement, .allowInCarPlay])
        

        center.setNotificationCategories([category])
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
                   case UNNotificationDefaultActionIdentifier:
                       // the user swiped to unlock
                       print("Default identifier")

                   case "show":
                       // the user tapped our "show more info…" button
                       print("Show more information…")

                   default:
                       break
                   }
            
        }
        completionHandler()
    }


}

