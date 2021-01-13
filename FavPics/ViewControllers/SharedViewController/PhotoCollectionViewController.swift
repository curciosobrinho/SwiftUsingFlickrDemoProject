//
//  PhotoCollectionViewController.swift
//  FavPics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import UIKit
import SDWebImage

/// to avoid using objc protocols (thus, limiting the usage), all methods are required
/// if you need to make them optional, use
/// @objc protocol PhotoCollectionDelegate:AnyObject and write optional word in front of the func

protocol PhotoCollectionDelegate: AnyObject {
    func didPressFavoriteForPhoto(photo: Photo)
    func didScrollNearTheEnd()
}

class PhotoCollectionViewCell : UICollectionViewCell {
    
    var imageView: UIImageView?
    var favoriteButton: UIButton?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews(frame: frame)
    }
    
    func addViews (frame: CGRect){
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.favoriteButton = UIButton(frame: CGRect(x: frame.width - 40, y: frame.height - 40, width: 30, height: 30))
        
        if let img = self.imageView {
            img.contentMode = .scaleToFill
            self.addSubview(img)
        }
        
        if let bt = self.favoriteButton {
            bt.setImage(UIImage(named: "heart"), for: .normal)
            self.addSubview(bt)
        }
    }

}

/// This class was all created in code just to be easier to reuse all around
/// and also to show that I know how to do it (I actually prefer do it on code)
/// as it is the same flow I left the button and image tap to have static actions
/// in a real environment a delegate would be prefered

class PhotoCollectViewController : UIViewController {
    
    let reuseIdentifier = "photocell"
    var photos: [Photo]?
    let itemsPerRow: CGFloat = 3
    var sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    var collectionView: UICollectionView?
    weak var delegate: PhotoCollectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
 
        view.addSubview(collectionView ?? UICollectionView())
        
        self.view = view
        
        AddObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func AddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFromNotification), name: .FavoriteChanged, object: nil)
    }
    
    @objc func reloadDataFromNotification() {
        reloadData()
    }
    
    func updatePhotos (photos : [Photo]) {
        self.photos = photos
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
}

// MARK: - UICollectionViewDataSource protocol
extension PhotoCollectViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoCollectionViewCell
        
        if let photo = self.photos?[indexPath.row] {
            cell.imageView?.sd_setImage(with: URL(string: photo.imageURL), placeholderImage: UIImage(named: "placeholder"))
            
            if (FavoriteStore.isPhotoFavorite(photo: photo)){
                cell.favoriteButton?.setImage(UIImage(named: "heart-red"), for: .normal)
            } else {
                cell.favoriteButton?.setImage(UIImage(named: "heart"), for: .normal)
            }
            cell.favoriteButton?.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
            cell.favoriteButton?.tag = indexPath.row
            cell.backgroundColor = UIColor.lightGray // make cell more visible in our example project
        }
        
        if indexPath.row == (self.photos!.count - 10) {
            if let delegate = delegate {
                delegate.didScrollNearTheEnd()
            }
        }

        return cell
    }
    
    @objc func didPressButton(_ sender: UIButton){
        let bt = sender
        if let photo = self.photos?[bt.tag] {
            
            FavoriteStore.tooglePhoto(photo: photo)
            
            reloadData()
            
            if let delegate = delegate {
                delegate.didPressFavoriteForPhoto(photo: photo)
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate protocol
extension PhotoCollectViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// as I said above, I left a static action, in this case saving
        /// in a real situation we could use a delegate
        if let photo = self.photos?[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: ImageDetailsViewController = (storyboard.instantiateViewController(withIdentifier: "ImageDetailsViewController") as? ImageDetailsViewController)!
            vc.photo = photo
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true)
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout protocol
extension PhotoCollectViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

      let paddingSpace = sectionInsets.left * (itemsPerRow + 2)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow

      return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
