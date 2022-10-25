//
//  NotificationManager.swift
//  InTimeApp
//
//  Created by Carlos Correia on 20/10/2022.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()
    
    func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SUCESS")
            }
        }
    }
    
    func scheduleNotification(task: TaskItem) {
        let content = UNMutableNotificationContent()
        content.title = task.name!
        content.subtitle = task.notes!
        content.sound = .default
        content.badge = 1
        
        /*  // By Time Interval - Sends a notification 5s after request
            let timeTrigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10.0,
            repeats: false)
        */
        
        //calendar
        let dateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: task.dueDate!)
        let calTrigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false)
        
        //location
        
        
        let request = UNNotificationRequest(
            identifier: task.notificationID!,
            content: content,
            trigger: calTrigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
