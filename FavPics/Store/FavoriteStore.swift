//
//  FavoriteStore.swift
//  FavPics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import UIKit

extension Notification.Name {
    static let FavoriteChanged = Notification.Name("FavoriteChanged")
}

struct FavoriteStore {
    
    private static let defaults = UserDefaults.standard
    
    static var allFavorites: [String : Photo] = [String : Photo] ()
    
    static func load () {
        do {
            if let encodedData: Data = defaults.object(forKey: "FavoritePhotos") as? Data {
                allFavorites = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedData) as! [String : Photo]
            }
        } catch  {
            print("error when loading favorites")
        }
        
    }
    
    private static func save () {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: allFavorites, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "FavoritePhotos")
        } catch {
            print("error when saving favorites")
        }
        
    }
    
    static func addPhoto (photo: Photo) {
        allFavorites[photo.id] = photo
        save()
    }
    
    static func removePhoto (photo: Photo) {
        allFavorites.removeValue(forKey: photo.id)
        save()
    }
    
    /// helper method to check if favorite
    static func isPhotoFavorite (photo: Photo) -> Bool {
        return allFavorites[photo.id] != nil
    }
    
    /// helper method to add or remove a favorite
    static func tooglePhoto (photo: Photo) {
        if (isPhotoFavorite(photo: photo)){
            removePhoto(photo: photo)
        } else {
            addPhoto(photo: photo)
        }
    }
}
