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
    var establishments = [Establishment]()
    var categoryName: String?
    
    var selectedIndexPath: NSIndexPath?
    
    let defaultCellHeight = EstablishmentTableViewCell.defaultCellHeight
    let expandedCellHeight = EstablishmentTableViewCell.expandedCellHeight
    
    private let cellId = "establishmentInCategoryTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(EstablishmentTableViewCell.self, forCellReuseIdentifier: cellId)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let name = self.categoryName {
            self.navigationItem.title = name
        }
        
        
        print(establishmentIDs)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return establishmentIDs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! EstablishmentTableViewCell
        
        let establishment = establishmentIDs[indexPath.row]
        let ref = FIRDatabase.database().reference().child("establishments").child(establishment)
        ref.observeEventType(.Value, withBlock: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                cell.nameLabel.text = dictionary["name"] as? String
                
                if let price = dictionary["priceRange"] as? String {
                    cell.priceRangeLabel.text = "Price Range: \(price)"
                }
                
                
                if let dislikes = dictionary["dislikes"] as? Double, likes = dictionary["likes"] as? Double {
                    let totalVotes = dislikes + likes
                    
                    let rating = likes / totalVotes
                
                    let percentRating = "\(round(rating * 100)) % "
                    cell.percentRatingLabel.text = percentRating
                }
                
            }
            
        }, withCancelBlock: nil)
        return cell
    }
    
    
    // Getting height for tableView
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            
            return self.expandedCellHeight
        } else {
            return self.defaultCellHeight
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPathsToReload = [NSIndexPath]()
        if let previous = previousIndexPath {
            indexPathsToReload += [previous]
            
        }
        
        if let current = selectedIndexPath {
            indexPathsToReload += [current]
        }
        
        if indexPathsToReload.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPathsToReload, withRowAnimation: .Automatic)
        }
    }
    
    // MARK: TableView Observers
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! EstablishmentTableViewCell).watchFrameChanges()
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
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


