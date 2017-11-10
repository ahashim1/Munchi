//
//  Extensions.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/9/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit

extension UIViewController{
    func selectRandomBusiness(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "popupVC") as! PopupViewController
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }

}
