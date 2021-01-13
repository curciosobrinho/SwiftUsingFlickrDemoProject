//
//  FeaturedViewController.swift
//  FavPics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import UIKit

class FeaturedViewController : UIViewController {
    
    var photoCollectionVC: PhotoCollectViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionVC = PhotoCollectViewController()
        photoCollectionVC?.sectionInsets = UIEdgeInsets(top: 100, left: 10, bottom: 100, right: 10)
        photoCollectionVC?.view.frame = self.view.bounds
        self.view.addSubview(photoCollectionVC!.view)
        FavoriteStore.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let service = FlickrSearchService()
        service.getFeaturedPhotos(pageNo: 1) { (result) in
            
            switch result {
            case .Success(let results):
                if let photos = results {
                    self.photoCollectionVC?.updatePhotos(photos: photos.photo)
                }
            case .Failure(let message):
                // here we would treat the failure with an alert or something
                print(message)
                return;
            case .Error(let error):
                // here we would treat the failure with an alert or something
                print(error)
                return;
                
            }
        }
    }
}
