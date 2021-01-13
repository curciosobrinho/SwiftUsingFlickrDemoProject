//
//  FlickrModels.swift
//  Fav Pics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import UIKit

struct SearchResults: Codable {
    let stat: String?
    let photos: Photos?
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let photo: [Photo]
    let total: MetadataType
}

enum MetadataType: Codable{
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .string(container.decode(String.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(MetadataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int):
            try container.encode(int)
        case .string(let string):
            try container.encode(string)
        }
    }
}

class Photo: NSObject, Codable, NSCoding {
    
    let farm : Int
    let id : String
    
    let isfamily : Int
    let isfriend : Int
    let ispublic : Int
    
    let owner: String
    let secret : String
    let server : String
    let title: String
    
    var imageURL: String {
        let urlString = String(format: FlickrConstants.imageURL, farm, server, id, secret)
        return urlString
    }
    
    var originalImageURL: String {
        let urlString = String(format: FlickrConstants.originalImageURL, farm, server, id, secret)
        return urlString
    }
    
    /// all the below is needed because we are saving the Favorites
    init(farm: Int, id: String, isfamily: Int, isfriend: Int, ispublic: Int, owner: String,
         secret: String, server: String, title: String) {
        self.farm = farm
        self.id = id
        self.isfamily = isfamily
        self.isfriend = isfriend
        self.ispublic = ispublic
        self.owner = owner
        self.secret = secret
        self.server = server
        self.title = title
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let farm : Int = aDecoder.decodeInteger(forKey: "farm")
        let id : String = aDecoder.decodeObject(forKey: "id") as! String
        
        let isfamily : Int = aDecoder.decodeInteger(forKey: "isfamily")
        let isfriend : Int = aDecoder.decodeInteger(forKey: "isfriend")
        let ispublic : Int = aDecoder.decodeInteger(forKey: "ispublic")
        
        let owner: String = aDecoder.decodeObject(forKey: "owner") as! String
        let secret : String = aDecoder.decodeObject(forKey: "secret") as! String
        let server : String = aDecoder.decodeObject(forKey: "server") as! String
        let title: String = aDecoder.decodeObject(forKey: "title") as! String
        
        self.init(farm: farm, id: id, isfamily: isfamily, isfriend: isfriend, ispublic: ispublic, owner: owner,
                  secret: secret, server: server, title: title)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(farm, forKey: "farm")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(isfamily, forKey: "isfamily")
        aCoder.encode(isfriend, forKey: "isfriend")
        aCoder.encode(ispublic, forKey: "ispublic")
        aCoder.encode(owner, forKey: "owner")
        aCoder.encode(secret, forKey: "secret")
        aCoder.encode(server, forKey: "server")
        aCoder.encode(title, forKey: "title")
    }
}
