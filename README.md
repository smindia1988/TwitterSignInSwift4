# TwitterSignInSwift4
Twitter SignIn, Share, Email Request with Block based structure, Swift 4 support

## Steps:
- Install Twitter Kit Using CocoaPods: https://github.com/twitter/twitter-kit-ios/wiki/Installation

- Add single class **SMTwitterSignIn+Block.swift** into your project

- Create Twitter app in dashboard and get your CONSUMER_KEY and CUSTUMER_SECRET_KEY from: https://apps.twitter.com/ 

- Replace your CONSUMER_KEY and CUSTUMER_SECRET_KEY into SMTwitterSignIn+Block.swift  > func initalise() 

- Add a URL scheme to your project like this: twitterkit-YOUR_CONSUMER_KEY 

https://developers.google.com/identity/sign-in/ios/images/xcode_infotab_url_type_values.png

Open your project configuration: double-click the project name in the left tree view. Select your app from the TARGETS section, then select the Info tab, and expand the URL Types section.

Click the + button, and add your consumerkey as a URL scheme.

For example: twitterkit-YOUR_CONSUMER_KEY

- Put Open URL delegate methods into your project delegate class. Methods are added in AppDelegate.swift


## How to use?

**Sign-In:**

@IBAction func btnTwitterLogIn(_ sender: Any) {
        
        // Sign-In
        SMTwitterSignIn.sharedInstance.signIn { (session, statusMessage, isSuccess) in
            print("Login success => User Id: \(String(describing: session?.userID))")
        }
    }
    
    
**Sign-Out:**

@IBAction func btnTwitterLogout(_ sender: Any) {
        
        //Sign-Out
        SMTwitterSignIn.sharedInstance.signOut()
    }
 
**Get User Email:**

@IBAction func btnRequestTwitterEmail(_ sender: Any) {
                        
        //Get user email...
        SMTwitterSignIn.sharedInstance.requestTwitterEmail { (session, email, statusMessage, isSuccess) in
            
            if(isSuccess)!{
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
 
**Share On Twitter:**

@IBAction func btnTwitterSharePressed(_ sender: UIButton) {
        
        //Share on twitter...
        guard let shareImg = UIImage.init(named: "usa") else{
            print("failed to get image")
            return
        }
        
        SMTwitterSignIn.sharedInstance.shareOnTwitter(initialText: "USA flag picture will be tweeted", image: shareImg, videoURL: nil) { (session, statusMessage, isSuccess) in
            
            if(isSuccess)!{
                //Procedd on success...
                print(statusMessage as Any)
            }
            else{
                //Stop on fail...
                print(statusMessage as Any)
            }
        }
    }

    
**Help Guide:** 

https://github.com/twitter/twitter-kit-ios/wiki/Installation

https://dev.twitter.com/web/sign-in/implementing



