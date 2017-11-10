//
//  LocationModel.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/6/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationModel{
    let locationManager = CLLocationManager()

    func getUserLocation() -> CLLocation?{
        var locValue: CLLocation?
        
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locValue = locationManager.location
        
        
        return locValue
    }
    
    
    
    func getUserCoordinates() -> CLLocationCoordinate2D?{
        if let locValue = getUserLocation(){
            return locValue.coordinate
        }
        
        return nil
    }
    
    func getUserAddress(getLocCompletionHandler: @escaping (_ addressString: String) -> Void){
        guard let locValue = getUserLocation() else{ return }
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(locValue) { (placemarks, error) in
            if let err = error {
                print(err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    guard let subThoroughfare = placemark.subThoroughfare, let thoroughfare = placemark.thoroughfare else{ return }
                    let str = subThoroughfare + " " + thoroughfare
                 
                    getLocCompletionHandler(str)
                } else {
                    print("placemark was nil")
                }
            } else {
                print("something went wrong")
            }
        }
        
    }
}
