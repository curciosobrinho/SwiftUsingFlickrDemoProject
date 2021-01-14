//
//  FavoritesViewController.swift
//  FavPics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import UIKit

class FavoritesViewController : UIViewController, PhotoCollectionDelegate {
    
    var photoCollectionVC: PhotoCollectViewController?
    var photos: [Photo] = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionVC = PhotoCollectViewController()
        photoCollectionVC?.sectionInsets = UIEdgeInsets(top: 100, left: 10, bottom: 100, right: 10)
        photoCollectionVC?.view.frame = self.view.bounds
        photoCollectionVC?.delegate = self
        self.view.addSubview(photoCollectionVC!.view)
        self.title = "Favorites"
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFromNotification), name: .FavoriteChanged, object: nil)
    }
    
    @objc func reloadDataFromNotification() {
        loadFavorites ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFavorites()
    }
    
    func loadFavorites () {
        let favPhotos = FavoriteStore.allFavorites.values
        photos.removeAll()
        for photo in favPhotos {
            photos.append(photo)
        }
        self.photoCollectionVC?.updatePhotos(photos: photos)
    }
    
    func didPressFavoriteForPhoto(photo: Photo) {
        
        /// we first remove the heart, then we update to give the user a better feedback
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.loadFavorites()
        }
    }
    
}
