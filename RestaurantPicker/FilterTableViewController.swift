//
//  FilterTableViewController.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/6/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var sortingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    let locationModel = LocationModel()
    let queryModel = QueryModel.sharedInstance
    
    @IBOutlet weak var dealSegmentedControl: UISegmentedControl!
    
    fileprivate func setupWidgets() {
        locationModel.getUserAddress { (address) in
            self.locationLabel.text = address
        }
        radiusSlider.isContinuous = false
        radiusSlider.value = Float(queryModel.radiusFilter/1600)
        roundValue(radiusSlider)
        termTextField.text = queryModel.term
        sortingSegmentedControl.selectedSegmentIndex = queryModel.sort
        if queryModel.deals {
            dealSegmentedControl.selectedSegmentIndex = 1
        }else{
            dealSegmentedControl.selectedSegmentIndex = 0
        }
        setupRadiusLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWidgets()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutside(sender:)))
        self.view.addGestureRecognizer(tap)
        termTextField.delegate = self
    }

    func setupRadiusLabel(){
        if radiusSlider.value == 1{
            let mile = NSLocalizedString(" mile", comment: "mile string")
            radiusLabel.text = "1" + mile
        }else{
            
            let miles = NSLocalizedString(" miles", comment: "miles string")
            radiusLabel.text = String(Int(radiusSlider.value)) + miles
        }
        
    }

    // Make it so the only cell that can be selected is the location one. Not configured to be changed yet
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath != IndexPath(row: 0, section: 1){
            return nil
        }
        return indexPath
    }

    fileprivate func roundValue(_ sender: UISlider) {
        let step: Float = 5
        let roundedValue = roundf(sender.value/step) * step;
        sender.value = roundedValue
    }
    
    @IBAction func radiusSliderChanged(_ sender: UISlider) {
        roundValue(sender)
        setupRadiusLabel()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        queryModel.updateFilters(term: termTextField.text, sort: sortingSegmentedControl.selectedSegmentIndex, radius: radiusSlider.value, deals: dealSegmentedControl.selectedSegmentIndex)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    @objc func tappedOutside(sender: UITapGestureRecognizer){
        termTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        termTextField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
}
