//
//  FlickerService.swift
//  Fav Pics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import UIKit

enum Result <T>{
    case Success(T)
    case Failure(String)
    case Error(String)
}

enum RequestConfig {
    
    case searchRequest(String, Int)
    
    var value: URL? {
        
        switch self {
        
        case .searchRequest(let searchText, let pageNo):
            let urlString = String(format: FlickrConstants.searchURL, searchText, pageNo)
            return URL(string: urlString)
        }
    }
}

class FlickrConstants {
    
    static let api_key = "49f0e475662a927886f24de907a5a4d3"
    static let per_page = 60
    static let featureURL = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(FlickrConstants.api_key)&format=json&nojsoncallback=1"
    static let searchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FlickrConstants.api_key)&format=json&nojsoncallback=1&safe_search=1&per_page=\(FlickrConstants.per_page)&text=%@&page=%ld"
    static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(FlickrConstants.size.url_s.value).jpg"
    static let originalImageURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(FlickrConstants.size.url_l.value).jpg"
    
    /// the size is for the longest side
    enum size: String {
        case url_sq = "s"   //small square 75x75
        case url_q = "q"    //large square 150x150
        case url_t = "t"    //thumbnail, 100
        case url_s = "m"    //small, 240
        case url_n = "n"    //small, 320
        case url_m = "-"    //medium, 500
        case url_z = "z"    //medium 640
        case url_c = "c"    //medium 800
        case url_l = "b"    //large, 1024
        case url_h = "h"    //large 1600
        case url_k = "k"    //large 2048
        case url_o = "o"    //original image (jpg, gif or png)
        
        var value: String {
            return self.rawValue
        }
    }
    
    static let defaultColumnCount: CGFloat = 3.0
}

class FlickrSearchService{
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    /// Flickr API Call using the "flickr.photos.search" method, to retrieve photos based on search text from a given page
    /// - Parameters:
    ///   - text: search term
    ///   - page: which page
    ///   - completion: completion handler to retrieve result
    /// @escaping is used as we use asynchronous work and invoke the closure as a callback
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<Photos?>) -> Void) {
        
        guard let requestUrl = RequestConfig.searchRequest(searchText.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, pageNo).value else {
            return
        }
        
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: requestUrl , completionHandler: { (data, response, error) in
            
            // let's make sure we clean up the dataTask
            defer {
                self.dataTask = nil
            }
            
            if let error = error{
                // treat error accordingly, for now will just log and return it
                print(error.localizedDescription)
                return completion(.Failure(error.localizedDescription))
                
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                
                if let model = self.processResponse(data),
                   let stat = model.stat, stat.uppercased().contains("OK") {
                    return completion(.Success(model.photos))
                }
                
            } else {
                // treat error accordingly, for now will just log and return it
                return completion(.Failure("Something bad happened with the result, please check internet connection"))
            }
        })
        
        dataTask?.resume()
    }
    
    func getFeaturedPhotos(pageNo: Int, completion: @escaping (Result<Photos?>) -> Void) {
        
        dataTask?.cancel()
        
        guard let requestUrl = URL(string: FlickrConstants.featureURL) else {
            return
        }
        
        dataTask = defaultSession.dataTask(with: requestUrl , completionHandler: { (data, response, error) in
            
            // let's make sure we clean up the dataTask
            defer {
                self.dataTask = nil
            }
            
            if let error = error{
                // treat error accordingly, for now will just log and return it
                print(error.localizedDescription)
                return completion(.Failure(error.localizedDescription))
                
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                
                if let model = self.processResponse(data),
                   let stat = model.stat, stat.uppercased().contains("OK") {
                    return completion(.Success(model.photos))
                }
                
            } else {
                // treat error accordingly, for now will just log and return it
                return completion(.Failure("Something bad happened with the result, please check internet connection"))
            }
        })
        
        dataTask?.resume()
    }
    
    func processResponse(_ data: Data) -> SearchResults? {
        do {
            let responseModel = try JSONDecoder().decode(SearchResults.self, from: data)
            return responseModel
            
        } catch {
            print("Data parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}
