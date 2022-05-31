//
//  AppDelegate.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 10/14/21.
//

import UIKit
import CoreData
import Firebase
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "bBDRU0W72SYPkd6StZBdGT25c3RLqYG2e1qasVJH"
            $0.clientKey = "eZUFS9QJ3C4Ii3xySxd9ExhmEPlyJNJqC4TewrIL"
            $0.server = "https://parseapi.back4app.com"
        }
        
        Parse.initialize(with: configuration)

        return true
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

