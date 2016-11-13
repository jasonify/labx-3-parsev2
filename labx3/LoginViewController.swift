//
//  LoginViewController.swift
//  labx3
//
//  Created by jason on 10/27/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {

    
    var user: PFUser?
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLogin(_ sender: AnyObject) {
        
       /* PFUser.logInWithUsernameInBackground("myname", password:"mypass") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
            } else {
                // The login failed. Check error to see why.
            }
 */
        
        PFUser.logInWithUsername(inBackground:  "myUsername22Jason", password: "myPasswor22d223232") { (user: PFUser?, error:Error?) in
            if let error = error {
                print("ERROR")
            } else{
                print(user)
                print(user?.email)
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                self.user = user
                
                let userVC = mainStoryboard.instantiateViewController(withIdentifier: "chatView") as! ChatViewController

                self.present(userVC, animated: true, completion: nil)

                
            }
        }
            
    }
    
    @IBAction func onSingup(_ sender: AnyObject) {
        
            var user = PFUser()
            user.username = "myUsername22Jason"
            user.password = "myPasswor22d223232"
            user.email = "email@exam2sdfple.com"
            // other fields can be set just like with PFObject
            user["phone"] = "415-392-0202"
            
        user.signUpInBackground { (success: Bool, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
                // Show the errorString somewhere and let the user try again.
            } else {
                print("SUCCESS")
                // Hooray! Let them use the app now.
            }
        }
    

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        var destinationViewController = segue.destination as! ChatViewController
        
        destinationViewController.user = self.user
    }
    

}
