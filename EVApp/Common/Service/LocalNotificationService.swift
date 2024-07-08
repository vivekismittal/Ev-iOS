//
//  LocalNotificationService.swift
//  EVApp
//
//  Created by VM on 03/07/24.
//

import Foundation
import UserNotifications
import NotificationBannerSwift

enum UNNotificationIdentifier: String{
    case chargingOnGoing
}

class LocalNotificationService: LocalNotificationProtocol{
    let notificationCenter = UNUserNotificationCenter.current()

    private func checkForPermissions( completionHandler: @escaping (()->Void) ){
        notificationCenter.getNotificationSettings { setting in
            switch setting.authorizationStatus{
            case .authorized:
                completionHandler()
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]){ isAllow, error in
                    if isAllow{
                        completionHandler()
                    }
                }
            case .denied:
                break
            default:
                break
            }
        }
    }
    
    func dispatchNotification(title: String,body: String,identifier: UNNotificationIdentifier,userInfo: (any Codable)? = nil){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            let banner = NotificationBanner(title: title, subtitle: body, style: .success)
            banner.backgroundColor = #colorLiteral(red: 0.4919497967, green: 0.7860459685, blue: 0, alpha: 1)
            banner.applyStyling(titleTextAlign: .center, subtitleTextAlign: .center)
            banner.show()
        }
        
        checkForPermissions(){[weak self] in
            self?.notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier.rawValue])
            let content = UNMutableNotificationContent()
            content.title = title
            content.sound = .defaultCritical
            content.body = body
            content.badge = 1
            do{
                if let userInfo{
                    content.userInfo[identifier.rawValue] = try JSONEncoder().encode(userInfo)
                }
            } catch{}
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: identifier.rawValue, content: content, trigger: trigger)
            self?.notificationCenter.add(request){error in
                if let error {
                    print("Error adding notification: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeNotification(_ identifier: UNNotificationIdentifier){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier.rawValue])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier.rawValue])
    }
}


protocol LocalNotificationProtocol{
    func dispatchNotification(title: String,body: String,identifier: UNNotificationIdentifier,userInfo: (any Codable)?)
    func removeNotification(_ identifier: UNNotificationIdentifier)
}
