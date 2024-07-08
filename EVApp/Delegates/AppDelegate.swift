//
//  AppDelegate.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 16/05/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var currentVersion: Float = 1.6
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(" AIzaSyCHqc7kJr-jhIkxcCESdpoB9Ym8Kw8A2MY")
        GMSPlacesClient.provideAPIKey(" AIzaSyCHqc7kJr-jhIkxcCESdpoB9Ym8Kw8A2MY")
        IQKeyboardManager.shared.enable = true
     
        if(launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil){
              // your code here
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["Renish":"Dadhaniya"])
          }
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
        (granted, error) in
        guard granted else { return }
        DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
        }
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
//        let tokenParts = deviceToken.map { data -> String in
//            return String(format: "%02.2hhx", data)
//        }
//        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
//        print("Device Token: \(token)")
        _ = Bundle.main.bundleIdentifier;
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
   
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        print("local notification received")
//    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.ArrayLiteralElement(arrayLiteral: [.badge,.list,.sound]))
    }
    
    // MARK: Hand notification in forground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    // MARK: Handle notification in background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard ((UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController) != nil else {
            return
        }
        
       if UserAppStorage.didUserLoggedIn {
           if let identifier = UNNotificationIdentifier(rawValue: response.notification.request.identifier),
              identifier == .chargingOnGoing{
               if let vcData = response.notification.request.content.userInfo[identifier.rawValue] as? Data{
                   do{
                       let chargingVCData = try JSONDecoder().decode(ChargingVCModel.self, from: vcData)
                       let chargingVC = ChargingVC.instantiateUsingStoryboard(chargingVCData)
                       if let navigationController =  (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController as? UINavigationController {
                           navigationController.popToRootViewController(animated: false)
                           navigationController.pushViewController(chargingVC, animated: true)
                       }
                   } catch{}
               }
           } else {
               let landingScreen = ChargingSessionVC.instantiateUsingStoryboard()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController = landingScreen
           }
        }
        completionHandler()
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
}


