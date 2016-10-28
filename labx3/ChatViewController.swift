//
//  ChatViewController.swift
//  labx3
//
//  Created by jason on 10/27/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

import Parse
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var user : PFUser?
    var msgs : [PFObject]?
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var chatField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
      //  fetchMsgs()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.fetchMsgs), userInfo: nil, repeats: true)

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
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! BlahTableViewCell
        let obj = msgs?[indexPath.row]
        let msgX =  obj?.object(forKey: "text") as! String
        
        
       
        (cell.msgStack.arrangedSubviews[0] as! UILabel).text = msgX
        
        
        
        
        return cell
    }
    
    
    
    func fetchMsgs(){
       
        print("GOT STUFF")
        
        var query = PFQuery(className:"MessageSF")
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
        
        var gameScore = PFObject(className:"MessageSF")
       
        gameScore["text"] = chatField.text
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