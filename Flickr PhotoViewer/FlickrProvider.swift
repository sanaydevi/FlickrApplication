//
//  FlickrProvider.swift
//  Flickr PhotoViewer
//
//  Created by Sanay Devi on 2/15/19.

import Foundation

class FlickrProvider {
    
    typealias FlickrResponse = (NSError?, [FlickrPhoto]?) -> Void
    typealias FlickrMeta = (NSError?, FlickrPhotoMeta?) -> Void
    
    
    struct Keys {
        static let flickrKey = "2a83295107d057cf2a23e799a08f9ad7"
    }
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    class func fetchPhotosForSearchText(searchText: String, onCompletion: @escaping FlickrResponse) -> Void {
        let escapedSearchText: String = searchText.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Keys.flickrKey)&tags=\(escapedSearchText)&per_page=25&format=json&nojsoncallback=1"
        let url: NSURL = NSURL(string: urlString)!
        let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(error)")
                onCompletion(error as NSError?, nil)
                return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                guard let results = resultsDictionary else { return }
                print("Its working")
                if let statusCode = results["code"] as? Int {
                    if statusCode == Errors.invalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                        onCompletion(invalidAccessError, nil)
                        return
                    }
                }
                
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else { return }
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else { return }
                
                let flickrPhotos: [FlickrPhoto] = photosArray.map { photoDictionary in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    return flickrPhoto
                }
                
                onCompletion(nil, flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }
            
        })
        searchTask.resume()
    }
    
    class func getMetaData(photoId:String, onCompletion : @escaping FlickrMeta) -> Void {
       
        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(Keys.flickrKey)&photo_id=\(photoId)&format=json&nojsoncallback=1"
        let url: NSURL = NSURL(string: urlString)!
        let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(error)")
                onCompletion(error as NSError?, nil)
                return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                guard let results = resultsDictionary else { return }
                print("Its working")
                if let statusCode = results["code"] as? Int {
                    if statusCode == Errors.invalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                        onCompletion(invalidAccessError, nil)
                        return
                    }
                }
                
                guard let photosContainer = resultsDictionary!["photo"] as? NSDictionary else { return }
                guard let owner = photosContainer["owner"]  as? NSDictionary else {return}
                let username = owner["username"]
                let location = owner["location"]
                guard let titleDict = photosContainer["title"] as? NSDictionary else {return }
                let title = titleDict["_content"]
                guard let commentDict = photosContainer["comments"] as? NSDictionary else {return}
                let numberOfComments = commentDict["_content"]
                guard let dates = photosContainer["dates"] as? NSDictionary else{return}
                let dateTaken = dates["taken"]
                guard let visibility = photosContainer["visibility"] as? NSDictionary else{return}
                print("VISIBILITY")
                print(visibility)
                let flickrPhotos = FlickrPhotoMeta(username:username as! String, numberOfComments:numberOfComments as! String,title:title as! String,location:location as! String,date:dateTaken as! String)
                
                onCompletion(nil, flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }
            
        })
        searchTask.resume()
        
        
    }
    
    
   
}

