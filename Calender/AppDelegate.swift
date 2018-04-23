//
//  AppDelegate.swift
//  Calender
//
//  Created by Hazuki♪ on 1/31/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseStorage
import FirebaseDatabase
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
   
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        
        var allUserArray = Array<Dictionary<String,String>>()
         var userDefaults:UserDefaults = UserDefaults.standard
        let lef = Database.database().reference()
        lef.child("UserIDArray").observe(.childAdded, with: { [weak self](snapshot) -> Void in
            print("hoge")
            print(snapshot.key)
            let id = String(describing: snapshot.childSnapshot(forPath: "userID").value!)
            print(id)
            var user: Dictionary<String,String> = ["user":id]
            allUserArray.append(user)
            userDefaults.set(allUserArray, forKey: "allUser")
        })
        
        lef.child("UserIDArray").observe(.childRemoved, with: { [weak self](snapshot) -> Void in
            print("hogehogehoge")
            print(snapshot.key)
            let id = String(describing: snapshot.childSnapshot(forPath: "userID").value!)
            print(id)
            for i in 0 ..< allUserArray.count{
                if allUserArray[i]["user"] == id {
                    print("hogehoge")
                    print(snapshot.key)
                    print(i)
                    allUserArray.remove(at: i)
                    print(allUserArray)
                    break
                }
            }
            
            userDefaults.set(allUserArray, forKey: "allUser")
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
