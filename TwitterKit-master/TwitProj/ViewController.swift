//
//  ViewController.swift
//  TwitProj
//
//  Created by Sandip Patel (SM) on 06/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet var imgTweet: UIImageView!
    @IBOutlet var tvTweet: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button Actions
    @IBAction func btnTwitterLogIn(_ sender: Any) {
        
        // Sign-In
//        SMTwitterSignIn.sharedInstance.signIn { (session, statusMessage, isSuccess) in
//            print("Login success => User Id: \(String(describing: session?.userID))")
//        }
        
        //Sign-In + Email Request
        var strUserId : String = ""
        var strUserEmail: String = ""
        
        SMTwitterSignIn.sharedInstance.signOut()
        SMTwitterSignIn.sharedInstance.signIn { (session, statusMessageLogin, isSuccess) in
            
            if(isSuccess){
                
                if(session != nil){
                    strUserId = (session?.userID)!
                }
                print("Login success, Requesing user email id...")
                
                //Get user email...
                SMTwitterSignIn.sharedInstance.requestTwitterEmail { (session, email, statusMessageEmail, isSuccess) in
                    
                    if(isSuccess){
                        print(statusMessageEmail! as Any)
                        if(email != nil){
                            strUserEmail = email!
                        }
                    }
                    else{
                        print(statusMessageEmail! as Any)
                    }
                    
                    print("User Id: \(strUserId)")
                    print("User Email: \(strUserEmail)")
                    Alert.showAlert(title: "Twitter", message: "\(statusMessageLogin!) \n User Id: \(strUserId) \n User Email: \(strUserEmail)")
                }
            }
            else{
                Alert.showAlert(title: "Twitter", message: statusMessageLogin!)
            }
        }
    }
    
    @IBAction func btnTwitterSharePressed(_ sender: UIButton) {
        
        //Share on twitter...
        guard let shareImg = UIImage.init(named: "usa") else{
            print("failed to get image")
            return
        }
        
        SMTwitterSignIn.sharedInstance.shareOnTwitter(initialText: "USA flag picture will be tweeted", image: shareImg, videoURL: nil) { (session, statusMessage, isSuccess) in
            
            if(isSuccess){
                //Procedd on success...
                print(statusMessage as Any)
            }
            else{
                //Stop on fail...
                print(statusMessage as Any)
            }
        }
    }
    
    @IBAction func btnRequestTwitterEmail(_ sender: Any) {
                        
        //Get user email...
        SMTwitterSignIn.sharedInstance.requestTwitterEmail { (session, email, statusMessage, isSuccess) in
            
            if(isSuccess){
                //Procedd on success...
                print(statusMessage as Any)
                print("User Email: \(String(describing: email))")
            }
            else{
                //Stop on fail...
                print(statusMessage as Any)
            }
        }
    }
    
    @IBAction func btnTwitterLogout(_ sender: Any) {
        
        //Sign-Out
        SMTwitterSignIn.sharedInstance.signOut()
    }
    
}

