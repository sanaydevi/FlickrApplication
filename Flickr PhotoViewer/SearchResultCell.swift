//
//  SearchResultCell.swift
//  Flickr PhotoViewer
//
//  Created by Sanay Devi on 2/15/19.

import Foundation
import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    func setupWithPhoto(flickrPhoto: FlickrPhoto) {
        resultImageView.sd_setImage(with: flickrPhoto.photoUrl as URL!)
    }
    
}
    
