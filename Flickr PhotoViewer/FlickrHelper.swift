//
//  FlickrHelper.swift
//  Flickr PhotoViewer
//
//  Created by Sanay Devi 

import UIKit
import FlickrKit


class FlickrHelper {
    
    
    var completeAuthOp: FKDUNetworkOperation!
    var checkAuthOp: FKDUNetworkOperation!
    
    
    //For Authenticating User 
    func checkAuthentication(callBackURL: URL, sender: UIViewController, _ completionHandler : (()->Void?)?) {
        
        self.completeAuthOp = FlickrKit.shared().completeAuth(with: callBackURL, completion: { (userName, userId, fullName, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if ((error == nil)) {
                    
                    User.shared().getProfileInfo(userName: userName, fullName: fullName, userId: userId)
                    
                    
                } else {
                    
                    guard let message = error?.localizedDescription else{
                        return
                    }
                    
                    Util.showAlert(sender: sender, title: "Sorry", message: message)
                    
                    
                }
                completionHandler?()
                
                
            });
        })
        
        
    }
    //Called once the User is logged in after Authentication
    func login(sender: UIViewController, _ completionHandler : @escaping ((_ error: NSError?)->Void)){
        self.checkAuthOp = FlickrKit.shared().checkAuthorization { (userName, userId, fullName, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if ((error == nil)) {
                    
                    User.shared().getProfileInfo(userName: userName, fullName: fullName, userId: userId)
                    completionHandler(nil)
                    
                } else {
                    guard let message = error?.localizedDescription else{
                        return
                    }
                    
                    Util.showAlert(sender: sender, title: "Error", message: message)
                    
                    completionHandler(error as? NSError)
                    
                }
            });
            
        }
        
        
        
    }
    
    
    
    
    
    
    
}
