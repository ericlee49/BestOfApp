//
//  CategoryTableViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-08-25.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit
import Firebase

class EstablishmentsInCategoryTableViewController: UITableViewController {

    var establishmentIDs = [String]()
    var sortedEstablishmentIDs = [String]()
    var establishments = [Establishment]()
    var categoryName: String?
    
    var establishmentDictionary = [String:String]()
    
    var selectedIndexPath: IndexPath?
    
    let defaultCellHeight = EstablishmentTableViewCell.defaultCellHeight
    let expandedCellHeight = EstablishmentTableViewCell.expandedCellHeight
    
    var userAuthBool = false
    
    // USER ID:
    var userID: String = ""
    
    fileprivate let cellId = "establishmentInCategoryTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(EstablishmentTableViewCell.self, forCellReuseIdentifier: cellId)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let name = self.categoryName {
            self.navigationItem.title = name
        }
        
        loadEstablishments()

        firebaseUserAuth()
    }
    
    
    
    // MARK: Helper methods
    
    func loadEstablishments() {
       
        DispatchQueue.global(qos: .background).async {
            let establishmentsRef = FIRDatabase.database().reference().child("establishments")
            for id in self.establishmentIDs {
                
                establishmentsRef.child(id).observe(.value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        
                        let name = dictionary["name"] as? String
                        
                        let price = dictionary["priceRange"] as? String
                        
                        let dislikes = dictionary["dislikes"] as? Double
                        
                        let likes = dictionary["likes"] as? Double
                        
                        let address = dictionary["address"] as? String
                        
                        let phone = dictionary["phone"] as? String
                        
                        guard self.establishmentDictionary[name!] == nil else{
                            return
                        }
                        
                        self.establishmentDictionary[name!] = id
                        
                        let establishment = Establishment(name: name!, likes: likes!, dislikes: dislikes!, priceRange: price!, phone: phone!, address: address!, id: id)
                        
                        self.establishments.append(establishment)
                        self.establishments.sort(by: { (e1, e2) -> Bool in
                            (e1.likes / (e1.likes + e1.dislikes)) > (e2.likes / (e2.likes + e2.dislikes))
                        })
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            print("back to main queue")
            
                        }
                        
                    }
                    
                })
                    
                
            }
            

 
        }
        
        
        
        
    }
    
    func produceRating(_ likes:Double, _ dislikes:Double) -> String {
        let totalVotes = dislikes + likes
        let rating = likes / totalVotes
        let percentRating = "\(round(rating * 100)) % "
        return percentRating
    }
    
    // helper method to add establishment to user's voted list
    func confirmVoteForUserOnDatabase(_ index:Int, _ like:Bool) {
        guard !self.userID.isEmpty else{
            return
        }
        let ref = FIRDatabase.database().reference()
        print(self.userID)
        if like {
            ref.child("users").child(self.userID).child("votedEstablishments").child(self.establishmentIDs[index]).setValue("like")
        } else {
            ref.child("users").child(self.userID).child("votedEstablishments").child(self.establishmentIDs[index]).setValue("dislike")
        }
        
    }

    // LIKE ACTION:
    func likeButtonAction() {
        if !userAuthBool {
            self.loginRegisterAlert()
            let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as! EstablishmentTableViewCell
            cell.likeButton.backgroundColor = UIColor.gray
            
            return
        }
     
        if let i = self.selectedIndexPath?.row {
            
            //check if user has voted for this establishment
            let userRef = FIRDatabase.database().reference().child("users").child(userID).child("votedEstablishments")
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(self.establishmentIDs[i]){
                    // user has already voted for this establishment
                    let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as! EstablishmentTableViewCell
                    cell.likeButton.backgroundColor = UIColor.lightGray
                    cell.dislikeButton.backgroundColor = UIColor.lightGray
                    print("Child exists")
                    self.previousVoteAlert()
                } else {
                    print("NO child")
                    self.establishments[i].likes += 1
                    let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as! EstablishmentTableViewCell
                    cell.likeButton.backgroundColor = UIColor.gray
                    self.tableView.reloadRows(at: [self.selectedIndexPath!], with: .automatic)
                    
                    let likes = self.establishments[i].likes
                    self.updateLike(i, likes)
                    
                    self.confirmVoteForUserOnDatabase(i, true)
                    
                }
                
            })
            
        }
        
    }
    
    //helper method for like Action
    func updateLike(_ establishmentIndex: Int, _ likes: Double){
        //let establishmentID = establishmentIDs[establishmentIndex]
        let establishmentID = establishments[establishmentIndex].id
        let establishmentRef = FIRDatabase.database().reference().child("establishments").child(establishmentID)
        establishmentRef.updateChildValues(["likes" : likes])
    }
    
    // DISLIKE ACTION:
    func dislikeButtonAction() {
        if !userAuthBool {
            self.loginRegisterAlert()
            let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as! EstablishmentTableViewCell
            cell.dislikeButton.backgroundColor = UIColor.gray
            return
        }
        
        
        if let i = self.selectedIndexPath?.row {
            
            
            //check if user has voted for this establishment
            let userRef = FIRDatabase.database().reference().child("users").child(userID).child("votedEstablishments")
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(self.establishmentIDs[i]){
                    // user has already voted for this establishment
                    let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as! EstablishmentTableViewCell
                    cell.likeButton.backgroundColor = UIColor.lightGray
                    cell.dislikeButton.backgroundColor = UIColor.lightGray
                    print("Child exists")
                    self.previousVoteAlert()
                } else {
                    self.establishments[i].dislikes += 1
                    let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as! EstablishmentTableViewCell
                    cell.dislikeButton.backgroundColor = UIColor.gray
                    self.tableView.reloadRows(at: [self.selectedIndexPath!], with: .automatic)
                    
                    let dislikes = self.establishments[i].dislikes
                    self.updateDislike(i, dislikes)
                    
                    self.confirmVoteForUserOnDatabase(i, false)
                    
                }
                
            })
        }
    }
    
    //helper method for dislike Action
    func updateDislike(_ establishmentIndex: Int, _ dislikes: Double){
        //let establishmentID = establishmentIDs[establishmentIndex]
        let establishmentID = establishments[establishmentIndex].id
        let establishmentRef = FIRDatabase.database().reference().child("establishments").child(establishmentID)
        establishmentRef.updateChildValues(["dislikes" : dislikes])
    }
    
    func changeButtonColor() {
        let cell = self.tableView.cellForRow(at: self.selectedIndexPath!) as! EstablishmentTableViewCell
        cell.likeButton.backgroundColor = UIColor(red: 168/255, green: 3/255, blue: 3/255, alpha: 1)
    }
    
    

    
    

    
    
    
    
    func loginRegisterAlert() {
        let alert = UIAlertController(title: "Sorry!", message: "Please login/register before liking/disliking", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            print(alert)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func previousVoteAlert() {
        let alert = UIAlertController(title: "Sorry!", message: "You have already submitted a vote!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            print(alert)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Firebase Auth
    func firebaseUserAuth() {
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                print("USER HERE:::::::::::")
                print(user.uid)
                self.userAuthBool = true
                self.userID = user.uid
            } else {
                self.userAuthBool = false
                
                
            }
        }

    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return establishments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EstablishmentTableViewCell

        //Use the establishments array that was loaded at viewDidLoad
        let establishment = establishments[(indexPath as NSIndexPath).row]
        cell.nameLabel.text = establishment.name
        cell.priceRangeLabel.text = "Price Range: \(establishment.priceRange)"
        cell.percentRatingLabel.text = produceRating(establishment.likes, establishment.dislikes)
        cell.addressLabel.text = establishment.address
        cell.phoneLabel.text = establishment.phone
        
        cell.likeButton.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(changeButtonColor), for: .touchDown)
        cell.dislikeButton.addTarget(self, action: #selector(dislikeButtonAction), for: .touchUpInside)
        cell.dislikeButton.addTarget(self, action: #selector(changeButtonColor), for: .touchDown)
        
        
        return cell
    }
    
    
    // Getting height for tableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            
            return self.expandedCellHeight
        } else {
            return self.defaultCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPathsToReload = [IndexPath]()
        if let previous = previousIndexPath {
            indexPathsToReload += [previous]
            
        }
        
        if let current = selectedIndexPath {
            indexPathsToReload += [current]
        }
        
        if indexPathsToReload.count > 0 {
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }
    
    // MARK: TableView Observers
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! EstablishmentTableViewCell).watchFrameChanges()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! EstablishmentTableViewCell).ignoreFrameChanges()
    }
    
    
 
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


