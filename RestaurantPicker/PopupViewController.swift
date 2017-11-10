//
//  PopupViewController.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/5/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit
import YelpAPI
class PopupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    let businessesModel = BusinessesModel.sharedInstance
    var pickerViewRows = 1000
    var randomRow: Int?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewRows
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = businessesModel.likedBusinesses[row % businessesModel.likedBusinesses.count].name
        let title = NSAttributedString(string: str, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return title
    }
    
    // Popup from http://www.seemuapps.com/how-to-make-a-pop-up-view
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if businessesModel.likedBusinesses.count > 0{
        let pickerViewMiddle = ((pickerViewRows / businessesModel.likedBusinesses.count) / 2) * businessesModel.likedBusinesses.count
        pickerView.selectRow(pickerViewMiddle, inComponent: 0, animated: true)
        }
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.showAnimate()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.removeAnimate()
        if let row = randomRow {
        let businessURL = businessesModel.likedBusinesses[row % businessesModel.likedBusinesses.count].url
        UIApplication.shared.open(businessURL, options: [:], completionHandler: nil)
        removeAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func scrollButton(_ sender: Any) {
        randomRow = Int(arc4random_uniform(UInt32(pickerViewRows)))
        
        pickerView.selectRow(randomRow!, inComponent: 0, animated: true)



    }
    
    
   
    
    
    
    
}
