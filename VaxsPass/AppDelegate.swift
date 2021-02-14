//
//  AppDelegate.swift
//  VaxsPass
//
//  Created by Nada Zeini on 2/12/21.
//

import UIKit
import ArcGIS
import GooglePlaces
import Firebase
import IQKeyboardManagerSwift
import ApiAI
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AGSArcGISRuntimeEnvironment.apiKey = "AAPK175781fbc4044b99bdd35a4347bde45deU7VJt25W0DC6qG3IzlX5lA5rmj7sC2ABbqcgdaA3iAF84u66vrhW6Wc4nt7KUXd"
       
        GMSPlacesClient.provideAPIKey("AIzaSyARNJeV0HUI1CcAVuKN6VQ__PwET2KZ6Rc")
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        // Dialogflow setup
        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = "AIzaSyA44UP8sSTsX3yLcaYQFOaaUGIgrBaVOws"
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
    }
}

