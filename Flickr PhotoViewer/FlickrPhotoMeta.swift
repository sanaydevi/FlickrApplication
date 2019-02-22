//
//  FlickrPhotoMeta.swift
//  Flickr PhotoViewer
//
//  Created by Sanay Devi on 2/15/19.


import Foundation
struct FlickrPhotoMeta {
    
    
    let username: String
    let numberOfComments: String
    let title: String
    let location: String
    let date: String
    init(username: String = "", numberOfComments: String = "", title: String = "", location: String = "", date: String = "") {
        self.username = username
        self.numberOfComments = numberOfComments
        self.title = title
        self.location = location
        self.date = date

        
    }
    
}
