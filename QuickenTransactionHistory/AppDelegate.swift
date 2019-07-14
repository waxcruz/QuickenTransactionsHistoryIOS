//
//  AppDelegate.swift
//  QuickenTransactionHistory
//
//  Created by Bill Weatherwax on 7/13/19.
//  Copyright © 2019 waxcruz. All rights reserved.
//

import UIKit
import SQLite


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // locate start database
//        let sqlPath = Bundle.main.path(forResource: "quickenTransactionsBackup", ofType: "sqlite")
        if let sqlPath = Bundle.main.path(forResource: "quickenTransactionsBackup", ofType: "sqlite") {
            do {
                let db = try Connection((sqlPath))
                let transactions = Table("transactions")
                let posted = Expression<String>("posted")
                let count = try db.scalar(transactions.count)
                print("Row count: \(count)")
                //            for transaction in try db.prepare(transactions) {
                //                print("posted: \(transaction[posted])")
                //            }
            } catch  {
                print("Connection error: ", error)
            }
        } else {
            print("no starter file found")
        }


    
//        var dbStarter : OpaquePointer = openDatabase(pathName: sqlPath!)!
//        print(dbStarter)
//        // locate device database
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
//        NSLog("Document Path: %@", documentsPath)
//        let dbPath = documentsPath.appending("/quickenTransactionsBackup.sqlite")
//        print(dbPath)
//
//        var db : OpaquePointer = openDatabase(pathName: dbPath)!
//        print(db)

        
        return true
    }
    
    
    func openDatabase(pathName : String) -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(pathName, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(pathName)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
        return nil
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

    func copyDatabaseIfNeeded(_ database: String) {
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("\(database).db")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let databaseInMainBundleURL = Bundle.main.resourceURL?.appendingPathComponent("\(database).db")
            
            do {
                try fileManager.copyItem(atPath: (databaseInMainBundleURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }
    
    
}

