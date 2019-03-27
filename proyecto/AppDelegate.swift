//
//  AppDelegate.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 21/01/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import GoogleMaps
//import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    static let googleMapsApiKey = "YOUR_API_KEY"
    static let googlePlacesAPIKey = "YOUR_API_KEY"

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Color de fondo UINavigationBar
        UINavigationBar.appearance().backgroundColor = UIColor(red: 21.0/255.0, green: 103.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        
        //Tipografía título UINavigationBar
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: barFont]
        }
        
         UIApplication.shared.statusBarStyle = .lightContent
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener {
            auth, user in
            let user = Auth.auth().currentUser
            if user != nil {
                // User is signed in.
                print("Automatic Sign In: \(user?.email)")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "Inicio")
                self.window!.rootViewController = initialViewController
                
            } else {
                // No user is signed in.
            }
        }
       // GMSServices.provideAPIKey(googleApiKey)
       // GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(AppDelegate.googleMapsApiKey)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     
    }
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "ProductosCompra")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
             
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
             
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

