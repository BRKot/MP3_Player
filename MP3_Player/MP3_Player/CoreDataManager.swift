//
//  StorageManager.swift
//  MP3_Player
//
//  Created by Databriz on 16/01/2025.
//

import UIKit
import CoreData

// MARK: - CRUD

public final class CoreDataManager: NSObject{
    public static let shared  = CoreDataManager()
    private override init(){}
    
    private var appDelegate: AppDelegate{
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext{
        appDelegate.persistentContainer.viewContext
    }
    
    public func createMusic(id: Int16,
                        musicURL: String,
                        author: String?,
                        musicName: String?,
                            coverImage: Data?){
        guard let musicEntitydescription = NSEntityDescription.entity(forEntityName: "MusicItems", in: context) else{
            return
        }
        let music = MusicItems(entity: musicEntitydescription, insertInto: context)
        music.id = id
        music.musicURL = musicURL
        music.musicName = musicName
        music.author = author
        music.coverImage = coverImage
        
        appDelegate.saveContext()
    }
    
    public func fetchMusics() -> [MusicItems]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicItems")
        do{
            return try context.fetch(fetchRequest) as? [MusicItems]
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public func fetchMusic(with id: Int16) -> MusicItems?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicItems")
        do{
            guard let musics = try? context.fetch(fetchRequest) as? [MusicItems] else{ return nil}
            return musics.first(where: {$0.id == id})
        }
    }
    
    public func deletAllMusicItems(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicItems")
        do{
            guard let musics = try? context.fetch(fetchRequest) as? [MusicItems] else{ return }
            musics.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
    } 
    
    public func deletMusicItemById(with id: Int16){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicItems")
        do{
            guard let musics = try? context.fetch(fetchRequest) as? [MusicItems],
                  let music = musics.first(where: {$0.id == id}) else { return }
            context.delete(music)
        }
        appDelegate.saveContext()
    }
}
