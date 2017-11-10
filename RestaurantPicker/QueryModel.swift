//
//  QueryModel.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 11/8/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import YelpAPI
import UIKit

class QueryModel{
    static var sharedInstance = QueryModel()
    private init() { }
    
    var term = "Dinner"
    var limit = 15
    var sort = 0
    var radiusFilter: Double = 16000
    var deals = false
    private let appId = "Y-kpQgK2KU36TcB6UPWuYA"
    private let appSecret = "he6tdeuk9t7sUnUmYzWlt1d2fyu07ekwNXac3bnu5TmLILs2Sv1a8HG57HvlyecG"
    
    func getQuery(coordinate: YLPCoordinate, getQueryCompletionHandler: @escaping (_ results: [YLPBusiness]) -> Void ){
        
        
        let query = YLPQuery(coordinate: coordinate)
        query.dealsFilter = deals
        query.term = term
        query.limit = UInt(limit)
        query.radiusFilter = radiusFilter
        switch sort {
        case 0:
            query.sort = .bestMatched
        case 1:
            query.sort = .distance
        case 2:
            query.sort = .highestRated
        case 3:
            query.sort = .mostReviewed
        default:
            query.sort = .bestMatched
        }
        
        YLPClient.authorize(withAppId: appId, secret: appSecret) { (client, error) in
            client?.search(with: query, completionHandler: { (result, error) in
                if let results = result?.businesses{
                    getQueryCompletionHandler(results)
                }
            })
        }
    }
    
    func updateFilters(term: String?, sort: Int, radius: Float, deals: Int){
        if let searchTerm = term{
            if !searchTerm.isEmpty{
                self.term = searchTerm
            }
        }
        
        self.sort = sort
        self.radiusFilter = Double(radius * 1600)
        self.deals = deals == 1
    }
    
}
