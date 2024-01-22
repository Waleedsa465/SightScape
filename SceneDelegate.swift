//
//  SceneDelegate.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

