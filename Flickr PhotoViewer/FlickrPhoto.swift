//
//  FlickrPhoto.swift
//  Flickr PhotoViewer
//
//  Created by Sanay Devi on 2/15/19.


import Foundation
import Foundation
import UIKit

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
}
