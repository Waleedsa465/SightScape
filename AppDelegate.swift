//
//  AppDelegate.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit
import IQKeyboardManagerSwift
import LanguageManager_iOS
import UserNotifications
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        LanguageManager.shared.defaultLanguage = .en
        //LanguageManager.shared.setLanguage(language: .en)
        
        if getDefaultObject(forKey: strApplanguageInitialSetting) == "1"{
            print("Initial set")
            if getDefaultObject(forKey: strCurrentApplanguage) == "en"{
                LanguageManager.shared.setLanguage(language: .en)
            }else if getDefaultObject(forKey: strCurrentApplanguage) == "ar"{
                LanguageManager.shared.setLanguage(language: .ar)
            }else{
                let currentDeviceLanguage = Locale.current.languageCode
                print("Current language is \(currentDeviceLanguage!)")
                LanguageManager.shared.setLanguage(language: Languages(rawValue: currentDeviceLanguage!)!)
            }
        }else{
            saveDefaultObject(obj: "1", forKey: strApplanguageInitialSetting)
            print("Initial not set")
            
            let currentDeviceLanguage = Locale.current.languageCode
            print("Current language is \(currentDeviceLanguage!)")
            saveDefaultObject(obj: currentDeviceLanguage!, forKey: strCurrentApplanguage)
            LanguageManager.shared.setLanguage(language: Languages(rawValue: currentDeviceLanguage!)!)
            
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }
    
    //MARK: User Notifications
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken!)")
        strTokenAPNS = fcmToken!
        //UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        //AppUtility!.saveObject(obj: fcmToken, forKey: strAPNSToken)
        //let dataDict:[String: String] = ["token": fcmToken]
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth.
        //let firebaseAuth = Auth.auth()
        
        //At development time we use .sandbox
        //firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        //At time of production it will be set to .prod
        
        //Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Apple token : \(token)")
        //strTokenAPNS = token
        //let defaults = UserDefaults.standard
        //defaults.set(token, forKey: "token")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if strAppStoreVersion.count != 0{
            
        }
        _ = try? isUpdateAvailable { (update, error) in
            if let error = error {
                print(error)
            } else if let update = update {
                print("New version available")
                print(update)
                isNewAppVersionAvailable = update
                if isNewAppVersionAvailable{
                    let alert = UIAlertController(title: strUpdateAlertTitle.localiz(), message: strUpdateAlertMsg.localiz(), preferredStyle: .alert)
                    let actionUpdate = UIAlertAction(title: "Update".localiz(), style: .default) { (a:UIAlertAction) in
                        isNewAppVersionAvailable = false
                        if let url = URL(string: "https://apps.apple.com/us/app/sightscape-vendor/id6470340053") {
                            UIApplication.shared.open(url)
                        }
                    }
                    alert.addAction(actionUpdate)
                    DispatchQueue.main.async {
                        UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

