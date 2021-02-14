//
//  AppDelegate.swift
//  VaxsPass
//
//  Created by Nada Zeini on 2/12/21.
//

import UIKit
import GooglePlaces
import Firebase
//import FirebaseDatabase
import IQKeyboardManagerSwift
import ApiAI
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //should hide keys lol
        
        GMSPlacesClient.provideAPIKey("AIzaSyARNJeV0HUI1CcAVuKN6VQ__PwET2KZ6Rc")
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        // Dialogflow setup
        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = "AIzaSyA44UP8sSTsX3yLcaYQFOaaUGIgrBaVOws"
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration
//        var ref: DatabaseReference!
//        ref = Database.database().reference().ref.child("userInfo")
        //realtime db setup
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
    }
}

