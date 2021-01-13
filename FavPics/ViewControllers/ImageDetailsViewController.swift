//
//  ImageDetails.swift
//  FavPics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import UIKit
import SDWebImage
import WebKit

class ImageDetailsViewController : UIViewController {
    
    var photo: Photo?
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = UIColor.white
        loadImage()
    }
    
    /// just left it more legible but breaking the lines
    func prepareHTML() -> String {
        let html = """
            <html><head>
                 <style>
                 img {
                     position: absolute;
                     top: 0;
                     bottom: 0;
                     left: 0;
                     right: 0;
                     margin: auto;
                 }
                 .image {
                     min-height: 200px
                 }
                </style>
                </head>
                <body style="background-color: #FFF;">
                <center>
                <img src="%@" class="image">
                </center>
                </body>
                </html>
"""
        return html
    }
    func loadImage() {
        
        if let photo = self.photo {
            self.title = photo.title
            checkFavorite(photo: photo)
            let html = String(format: prepareHTML(), photo.originalImageURL)
            webView.loadHTMLString(html, baseURL: URL(string: "http://localhost"))
        }
    }
    
    func checkFavorite(photo: Photo) {
        if (FavoriteStore.isPhotoFavorite(photo: photo)){
            favoriteButton.tintColor = UIColor.red
        } else {
            favoriteButton.tintColor = UIColor.gray
        }
        
        NotificationCenter.default.post(name: .FavoriteChanged, object: nil)
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressFavorite() {
        
        if let photo = self.photo {
            FavoriteStore.tooglePhoto(photo: photo)
            checkFavorite(photo: photo)
        }
    }
    
    @IBAction func didPressShare() {
        
        if let urlString = self.photo?.originalImageURL, let url = URL(string: urlString) {
            SDWebImageDownloader.shared.downloadImage(with: url) { (image, data, error, downloaded) in
                if let img = image {
                    let items = [img]
                    let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
                    self.present(ac, animated: true)
                }
            }
        }
    }
}
