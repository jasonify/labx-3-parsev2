//
//  ChatViewController.swift
//  labx3
//
//  Created by jason on 10/27/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

import Parse
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageViewPicked: UIImageView!
    var user : PFUser?
    var msgs : [PFObject]?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var chatField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
      
        
        //picker!.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
      //  fetchMsgs()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.fetchMsgs), userInfo: nil, repeats: true)
        
        fetchMsgs()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(msgs == nil){
            return 0
        }
        return msgs!.count
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        print("IMG!!")
        print(info)
        
         let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
         imageViewPicked.contentMode = .scaleAspectFit //3
         imageViewPicked.image = chosenImage //4
         dismiss(animated:true, completion: nil) //5
        
        
        
        
        
        
        let imageData = UIImagePNGRepresentation(chosenImage)
        let imageFile = PFFile(name:"x22imag222dsfse.png", data:imageData!)
      
        // image fiel size
        
        
        var imgData: NSData = NSData(data: UIImageJPEGRepresentation((chosenImage), 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        var imageSize: Int = imgData.length
        print("size of image in KB:  \(Double(imageSize) / 1024.0) ")
        

        
        var gameScore = PFObject(className:"MessageSF2017")
        
        gameScore["text"] = chatField.text
        gameScore["imageFile"] = imageFile
        gameScore["imageName"] = "My trip to Hawaii!"

        gameScore["user"] = PFUser.current()
        chatField.text = ""





        
        imageFile?.saveInBackground({
            (succeeded: Bool, error: Error?) -> Void in
            // Handle success or failure here ...
            print("YESSS!")
            }, progressBlock: {
                (percentDone: Int32) -> Void in
                // Update your progress spinner here. percentDone will be between 0 and 100.
                print("WTF")
                print(percentDone)
        })

        
        gameScore.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                
                print("HELLO WORKED")
                // The object has been saved.
                //self.fetchMsgs()
            } else {
                
                print("HELLO failed")
                
                // There was a problem, check error.description
            }
        }

        /*
 
 
        
        let str = "Working at Parse is great!"
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        let file = PFFile(name:"resume.txt", data:data)
        file.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            // Handle success or failure here ...
            }, progressBlock: {
                (percentDone: Int32) -> Void in
                // Update your progress spinner here. percentDone will be between 0 and 100.
        })
 */
        
        
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("CANCEL")
        dismiss(animated: true, completion: nil)

        
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! BlahTableViewCell
        let obj = msgs?[indexPath.row]
        let msgX =  obj?.object(forKey: "text") as! String
        
        let userX =  obj?.object(forKey: "user") as? PFUser

        
        
        
       
        (cell.msgStack.arrangedSubviews[0] as! UILabel).text = msgX
        
        
        
        if( userX == nil){
            cell.msgStack.arrangedSubviews[1].isHidden  = true
        } else{
            
            if(userX!.username != nil && userX!.email != nil){
            cell.msgStack.arrangedSubviews[1].isHidden  = false

            
            (cell.msgStack.arrangedSubviews[1] as! UILabel).text =
                "u: \(userX!.username!) ) "
            }
            
            
            
            
            
        }
        
        
        
        let userImageFile = obj?.object(forKey: "imageFile") as?  PFFile
        if let userImageFile = userImageFile {

            userImageFile.getDataInBackground(block: { (imageData:Data?, error:Error?) in
            
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.imageSelected.image = image
                    }
                } else {
                    print("error")
                }
                
            })
     
        }
        
        
        
        
        return cell
    }
    
    
    
    func fetchMsgs(){
       
        print("GOT STUFF")
        
        var query = PFQuery(className:"MessageSF2017")
        query.includeKey("user")
        //query.whereKey("playerName", equalTo:"Sean Plott")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                    }
                }
                
                self.msgs = objects
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                print("blah")
                // print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
    }

    @IBAction func onSendChat(_ sender: AnyObject) {
        
        var imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imgPicker.allowsEditing = false

        
        
        present(imgPicker, animated: false, completion: nil)
        
        /*
        
        var gameScore = PFObject(className:"MessageSF2016")
       
        gameScore["text"] = chatField.text
        
        gameScore["user"] = PFUser.current()
        chatField.text = ""
        gameScore.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                
                print("HELLO WORKED")
                // The object has been saved.
                //self.fetchMsgs()
            } else {
                
                print("HELLO failed")

                // There was a problem, check error.description
            }
        }
        */
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
