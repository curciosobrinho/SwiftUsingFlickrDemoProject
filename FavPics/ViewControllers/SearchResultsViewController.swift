//
//  SearchResultsViewController.swift
//  FavPics
//
//  Created by Curcio Jamunda Sobrinho on 13/01/21.
//

import UIKit

class SearchResultsViewController : UIViewController, PhotoCollectionDelegate {
    
    var photoCollectionVC: PhotoCollectViewController?
    let photosObj: Photos
    var photos: [Photo] = [Photo]()
    let searchTerm: String
    var currentPage: Int = 1
    
    init(photosObj: Photos, photos: [Photo], searchTerm: String) {
        self.photosObj = photosObj
        self.photos = photos
        self.searchTerm = searchTerm
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionVC = PhotoCollectViewController()
        photoCollectionVC?.sectionInsets = UIEdgeInsets(top: 100, left: 10, bottom: 100, right: 10)
        photoCollectionVC?.view.frame = self.view.bounds
        photoCollectionVC?.delegate = self
        self.view.addSubview(photoCollectionVC!.view)
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFromNotification), name: .FavoriteChanged, object: nil)
    }
    
    @objc func reloadDataFromNotification() {
        reloadData()
    }
    
    func reloadData() {
        self.photoCollectionVC?.updatePhotos(photos: photos)
    }
    
    func didScrollNearTheEnd() {
        
        let searchService = FlickrSearchService()
        
        
        if currentPage < photosObj.page {
            currentPage = photosObj.page
        }
        
        currentPage += 1
        
        searchService.request(searchTerm, pageNo: currentPage) { (result) in
            
            switch result {
            case .Success(let results):
                if let photos = results{
                    self.photos.append(contentsOf: photos.photo)
                    self.reloadData()
                }
            case .Failure(let message):
                // here we would treat the failure with an alert or something
                print(message)
            case .Error(let error):
                // here we would treat the failure with an alert or something
                print(error)
            }
            
        }
        
    }
    
    
}

