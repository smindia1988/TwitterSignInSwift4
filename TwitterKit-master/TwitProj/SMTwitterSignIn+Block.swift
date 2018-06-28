//
//  SMTwitterSignIn+Block.swift
//  TwitProj
//
//  Created by Sandip Patel (SM) on 06/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

/*
 TwitterKit Tutorial
 - Swift 4 language
 - iOS 11
 - Xcode 9
 - Twitter Login, Post a Tweet
 
 Downloading SDK: https://dev.twitter.com/twitterkit/io...
 Twitter app dashboard where you will create your own app: https://apps.twitter.com/
 Github project URL: https://github.com/cooper129/TwitterKit
 
 Help Guide:
 https://github.com/twitter/twitter-kit-ios/wiki/Installation
 https://dev.twitter.com/web/sign-in/implementing
 */

import UIKit
import TwitterKit
import TwitterCore

private typealias loginCompletionHandler = ((_ statusMessage:String,_ isSuccess:Bool)->())?  //For internal login check callBack
typealias completionHandler = ((_ session:TWTRSession?, _ statusMessage:String?, _ isSuccess:Bool?)->())?  //For Login and Share callBack
typealias emailCompletionHandler = ((_ session:TWTRSession?, _ email:String?, _ statusMessage:String?, _ isSuccess:Bool?)->())? //For Email Permission callBack

class SMTwitterSignIn: NSObject, TWTRComposerViewControllerDelegate {
    
    static let sharedInstance = SMTwitterSignIn()
    var globalHandler : completionHandler!
    let topVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
    
    //MARK:- Custom methods
    
    override init() {
        super.init()
        initalise()
    }
    
    func initalise(){
        // Initialize Twitter Sign-In
        //Twitter.sharedInstance().start(withConsumerKey: "Z506UKo0lOFc7nmP4NWOVBnbe", consumerSecret: "QyxJK6MCmuf58mjOiXHWLJDMTBuTyzk2aX1XNtsKtWHAQj52f9")
        TWTRTwitter.sharedInstance().start(withConsumerKey: "pTDcIOxGMGuWfXO3Bghmv4twL", consumerSecret: "TuHYIop6bIkP3nK2q7XmxG8o864EGgJL2jWjyposIwqv5Qwf5E")
    }
    
    func signIn(completionHandler:completionHandler){
        
        loginTwitterWithCompletionBlock { (statusMessage, isSuccess) in
            if(isSuccess){
                print(statusMessage)
            }
            else{
                print(statusMessage)
            }
            
            let store = TWTRTwitter.sharedInstance().sessionStore
            completionHandler!(store.session() as? TWTRSession,statusMessage,isSuccess)
        }
    }
    
    func signOut(){
        
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
            print("Success => Twitter logout successfully for UserId:\(userID)")
        }
    }
    
    func requestTwitterEmail(emailCompletionHandler:emailCompletionHandler) {
        
        loginTwitterWithCompletionBlock { (statusMessage, isSuccess) in
            if(isSuccess){
                
                print(statusMessage)
                
                //Request for email permission
                let client = TWTRAPIClient.withCurrentUser()
                client.requestEmail { email, error in
                    
                    if((error) != nil){
                        emailCompletionHandler!(TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession, nil, error?.localizedDescription, false)
                        return
                    }
                    
                    if (email != nil) {
                        print("User Email: \(email ?? "Not found")");
                        emailCompletionHandler!(TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession, email, "Requested email successfully", true)
                    }
                }
            }
            else{
                //Failed
                print(statusMessage)
                emailCompletionHandler!(TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession, nil, statusMessage, false)
            }
        }
    }
    
    func shareOnTwitter(initialText:String?, image:UIImage?, videoURL:URL?, completionHandler:completionHandler) {
        
        globalHandler = completionHandler
        
        loginTwitterWithCompletionBlock { (statusMessage, isSuccess) in
            if(isSuccess){
                //Procedd on success...
                print(statusMessage)
                
                //Show share dialog...
                let composer = TWTRComposerViewController.init(initialText: initialText ?? "", image: image, videoURL: videoURL)
                composer.delegate = self
                self.topVC?.present(composer, animated: true, completion: nil)
            }
            else{
                //Stop on fail...
                print(statusMessage)
                self.globalHandler!!(TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession, statusMessage, isSuccess)
            }
        }
    }
    
    private func loginTwitterWithCompletionBlock(loginCompletionHandler:loginCompletionHandler){
        
        //globalHandler!!(signIn, user, error)
        
        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // App must have at least one logged-in user to compose a Tweet
            loginCompletionHandler!("User Already Logged In", true)
        } else {
            // Log in, and then check again
            TWTRTwitter.sharedInstance().logIn { session, error in
                
                if((error) != nil){
                    loginCompletionHandler!((error?.localizedDescription)!, false)
                    return
                }
                
                if session != nil { //Log in succeeded and Session available
                    loginCompletionHandler!("Logged In Successfully", true)
                } else {
                    loginCompletionHandler!("Something went wrong, Please login again.", false)
                }
            }
        }
    }
    
    
    //MARK:- TWTRComposerViewControllerDelegate
    func composerDidCancel(_ controller: TWTRComposerViewController) {
        print("composerDidCancel, composer cancelled")
        self.globalHandler!!(TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession, "composerDidCancel, composer cancelled", false)
    }
    
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        print("composerDidSucceed, tweet successfully published")
        self.globalHandler!!(TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession, "composerDidSucceed, tweet successfully published", true)
    }
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
        print("composerDidFail, tweet publish failed == \(error.localizedDescription)")
        self.globalHandler!!(TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession, error.localizedDescription, false)
    }
    
}


