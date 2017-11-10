//
//  DisplayTableViewController.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/7/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit

class DisplayTableViewController: UITableViewController {

    
    var businessesModel = BusinessesModel.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return businessesModel.likedBusinesses.count
        }else{
            return businessesModel.dislikedBusinesses.count

        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Liked Businesses"
        }else{
            return "Disliked Businesses"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DisplayTableViewCell
        if indexPath.section == 0{
            cell.restaurantLabel.text = businessesModel.likedBusinesses[indexPath.row].name
            cell.categoryLabel.text = businessesModel.getBusinessCategoryName(businessesModel.likedBusinesses[indexPath.row])
            cell.ratingImageView.image = businessesModel.getBusinessRatingImage(businessesModel.likedBusinesses[indexPath.row])
        }else{
           cell.restaurantLabel.text = businessesModel.dislikedBusinesses[indexPath.row].name
            cell.categoryLabel.text = businessesModel.getBusinessCategoryName(businessesModel.dislikedBusinesses[indexPath.row])
            cell.ratingImageView.image = businessesModel.getBusinessRatingImage(businessesModel.dislikedBusinesses[indexPath.row])
        }
        cell.accessoryType = .disclosureIndicator
        cell.setupImageView()
        return cell
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if isEditing{
            setEditing(false, animated: true)
            sender.title = "Edit"
        }else{
            setEditing(true, animated: true)
            sender.title = "Done"

        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.section == 0{
            businessesModel.removeLikedBusiness(indexPath.row)
                
            }else{
                businessesModel.removeDislikedBusiness(indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        businessesModel.moveRow(from: sourceIndexPath, to: destinationIndexPath)
        
    }
    @IBAction func randomButtonTapped(_ sender: Any) {
        if businessesModel.likedBusinesses.count != 0{
            self.selectRandomBusiness()

        }
    }
}
