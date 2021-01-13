//
//  PictureModel.swift
//  Fav Pics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import Foundation

struct Picture {
    
    var isFavorite = false
    let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
}
