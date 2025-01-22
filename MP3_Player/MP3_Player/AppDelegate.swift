//
//  AppDelegate.swift
//  MP3_Player
//
//  Created by Databriz on 15/01/2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, 
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        
#if DEBUG
        // Удаление хранилища только в дебаг-режиме
        if let storeURL = container.persistentStoreDescriptions.first?.url {
            do {
                // Уничтожаем существующее хранилище
                try container.persistentStoreCoordinator.destroyPersistentStore(
                    at: storeURL,
                    type: .sqlite,
                    options: nil
                )
                
                // Удаляем связанные файлы
                let fileManager = FileManager.default
                try fileManager.removeItem(at: storeURL)
                
                // Удаляем вспомогательные файлы SQLite
                let shmURL = storeURL.deletingPathExtension().appendingPathExtension("sqlite-shm")
                let walURL = storeURL.deletingPathExtension().appendingPathExtension("sqlite-wal")
                try? fileManager.removeItem(at: shmURL)
                try? fileManager.removeItem(at: walURL)
            } catch {
                print("⚠️ Ошибка удаления хранилища: \(error)")
            }
        }
#endif
        
        container.loadPersistentStores { description, error in
            if let error{
                print(error)
            } else {
                print("DB url - ", description.url?.absoluteString as Any)
            }
        }
        return container
    }()
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
}

