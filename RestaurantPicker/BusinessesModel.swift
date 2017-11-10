//
//  BusinessesModel.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/7/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit
import YelpAPI

class BusinessesModel{
    static var sharedInstance = BusinessesModel()
    private init() { }
    
    var likedBusinesses: [YLPBusiness] = []
    var dislikedBusinesses: [YLPBusiness] = []
    var currentBusiness: YLPBusiness?
    var businesses: [YLPBusiness]?
    
    func addLikedBusiness(_ business: YLPBusiness){
        if !likedBusinesses.contains(business){
            likedBusinesses.append(business)
        }
    }
    
    func addDislikedBusiness(_ business: YLPBusiness){
        if !dislikedBusinesses.contains(business){
            dislikedBusinesses.append(business)
        }
    }
    
    func getBusinessImage(_ business: YLPBusiness) -> UIImage?{
        var imageData: Data?
        
        if let imageURL = business.imageURL{
            
            do {
                imageData = try Data(contentsOf: imageURL)
                //all fine with jsonData here
            } catch {
                //handle error
                print(error)
            }
        }
        
        if let data = imageData{
            return UIImage(data: data)
        }
        
        return nil
    }
    
    func getBusinessCategoryName(_ business: YLPBusiness) -> String?{
        if !business.categories.isEmpty{
            return business.categories.first?.name
        }
        
        return nil
    }
    
    func getBusinessRatingImage(_ business: YLPBusiness) -> UIImage?{
        let rating = business.rating
        var image: UIImage?
        if rating < 0.5{
            image = UIImage(imageLiteralResourceName: "0_stars")
        }else if rating < 1{
            image = UIImage(imageLiteralResourceName: "1_stars")
        }else if rating < 1.5{
            image = UIImage(imageLiteralResourceName: "1.5_stars")
        }else if rating < 2{
            image = UIImage(imageLiteralResourceName: "2_stars")
        }else if rating < 2.5{
            image = UIImage(imageLiteralResourceName: "2.5_stars")
        }else if rating < 3{
            image = UIImage(imageLiteralResourceName: "3_stars")
        }else if rating < 3.5{
            image = UIImage(imageLiteralResourceName: "3.5_stars")
        }else if rating < 4{
            image = UIImage(imageLiteralResourceName: "4_stars")
        }else if rating < 4.5{
            image = UIImage(imageLiteralResourceName: "4.5_stars")
        }else if rating < 5{
            image = UIImage(imageLiteralResourceName: "5_stars")
        }
        
        return image
    }
    
    func removeLikedBusiness(_ row: Int){
        likedBusinesses.remove(at: row)
    }
    func removeDislikedBusiness(_ row: Int){
        dislikedBusinesses.remove(at: row)
    }
    
    func moveRow(from fromIndex: IndexPath, to toIndex: IndexPath){
        if fromIndex != toIndex {
            if fromIndex.section != toIndex.section{
                if fromIndex.section == 0{
                    let business = likedBusinesses[fromIndex.row]
                    likedBusinesses.remove(at: fromIndex.row)
                    dislikedBusinesses.insert(business, at: toIndex.row)
                }else{
                    let business = dislikedBusinesses[fromIndex.row]
                    dislikedBusinesses.remove(at: fromIndex.row)
                    likedBusinesses.insert(business, at: toIndex.row)
                    
                }
            }else{
                if fromIndex.section == 0{
                    let business = likedBusinesses[fromIndex.row]
                    likedBusinesses.remove(at: fromIndex.row)
                    likedBusinesses.insert(business, at: toIndex.row)
                }else{
                    let business = dislikedBusinesses[fromIndex.row]
                    dislikedBusinesses.remove(at: fromIndex.row)
                    dislikedBusinesses.insert(business, at: toIndex.row)
                }
            }

        }
    }
}
