//
//  MusicItems+CoreDataProperties.swift
//  MP3_Player
//
//  Created by Databriz on 16/01/2025.
//
//

import Foundation
import CoreData


extension MusicItems {

    @NSManaged public var author: String?
    @NSManaged public var coverImage: Data?
    @NSManaged public var id: Int16
    @NSManaged public var musicName: String?
    @NSManaged public var musicURL: String?

}

extension MusicItems : Identifiable {

}

@objc(MusicItems)
public class MusicItems: NSManagedObject {

}
