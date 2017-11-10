//
//  ViewController.swift
//  RestaurantPicker
//
//  Created by Ali Hashim on 10/31/17.
//  Copyright © 2017 Ali Hashim. All rights reserved.
//

import UIKit
import YelpAPI
import CoreLocation
class ViewController: UIViewController, SwipingDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var numberReviewsLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var yelpImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let businessesModel = BusinessesModel.sharedInstance
    var businesses: [YLPBusiness]?
    var currentBusiness: YLPBusiness?
    var businessURL: URL?
    var index = 0
    let locationModel = LocationModel()
    let queryModel = QueryModel.sharedInstance
    let locationManager = CLLocationManager()
    let noMoreBusinessLabel = UILabel()
    
    func swipedLeft() {
        // necessary to avoid image flicker
        if let currentBusiness = currentBusiness{
            businessesModel.addDislikedBusiness(currentBusiness)
        }
        
        imageView.image = nil
        index += 1
        updateCard()
        cardView.alpha = 0
        cardView.transform = .identity
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.cardView.alpha = 1

        }, completion: nil)
        

    }
    
    func swipedRight() {
        if let currentBusiness = currentBusiness{
            businessesModel.addLikedBusiness(currentBusiness)
        }
        
        imageView.image = nil
        index += 1
        updateCard()

        cardView.alpha = 0
        cardView.transform = .identity
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.cardView.alpha = 1
        }, completion: nil)
    }
    
    
    
    
    func setupNoMoreBusinesses(){
        let str = NSLocalizedString("There are no businesses to show. Please refine your search or refresh.", comment: "No more string")
        noMoreBusinessLabel.text = str
        noMoreBusinessLabel.isHidden = true
        noMoreBusinessLabel.numberOfLines = 0
        noMoreBusinessLabel.font = UIFont.systemFont(ofSize: 18)
        noMoreBusinessLabel.textAlignment = .center
        self.view.addSubview(noMoreBusinessLabel)
        noMoreBusinessLabel.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        noMoreBusinessLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 10).isActive = true
        noMoreBusinessLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -10).isActive = true
        noMoreBusinessLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: 0).isActive = true
    }
    
    
    
   
    
    func setupCardView(){
        
        cardView.layer.borderColor = UIColor.black.cgColor
        cardView.layer.borderWidth = 2
        cardView.layer.cornerRadius = 10
        cardView.addGestureRecognizer(Swiping(target: self, action: #selector(self.swipeCard(sender:))))
        cardView.backgroundColor = UIColor(red: 147/255, green: 13/255, blue: 0, alpha: 1)
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowOpacity = 0.5
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(yelpImageTapped(sender:)))
        yelpImageView.addGestureRecognizer(gestureRecognizer)
        yelpImageView.isUserInteractionEnabled = true
    }
    
    
    func setupActivityIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    fileprivate func fetchData() {
        self.setupActivityIndicator()

        if let coordinates = locationModel.getUserCoordinates(){
            let yelpCoordinates = YLPCoordinate(latitude: coordinates.latitude, longitude: coordinates.longitude)
            queryModel.getQuery(coordinate: yelpCoordinates, getQueryCompletionHandler: { (results) in
                self.businesses = results
                DispatchQueue.main.async {
                    self.cardView.isHidden = false
                    self.likeButton.isEnabled = true
                    self.dislikeButton.isEnabled = true
                    self.noMoreBusinessLabel.isHidden = true
                    self.index = 0
                    self.updateCard()
                    self.activityIndicator.stopAnimating()
                    self.locationManager.stopUpdatingLocation()
                }
            })
        }
    }
    
   
   
    
  
    // From Professor's Lecture 13
    func showAlert(title: String, message: String) {
        let openSettings = {(action: UIAlertAction) -> Void in
            UIApplication.shared.open(
                URL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        let ac = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .cancel,
                                     handler: nil)
        ac.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings",
                                           style: .default,
                                           handler: openSettings)
        ac.addAction(settingsAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = nil
        self.setupCardView()
        self.setupNoMoreBusinesses()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Yes")
        if status == .denied || status == .restricted{
            showAlert(title: "Need Location Services", message: "This app needs permission to use location")
        }else if status == .notDetermined{
            manager.requestWhenInUseAuthorization()
        }
        
        fetchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func swipeCard(sender: Swiping){
        sender.swipingDelegate = self
        sender.swipeAction(view: cardView)
    }

    @IBAction func dislikeButtonTapped(_ sender: Any) {
        if let swiping = cardView.gestureRecognizers?.first as? Swiping{
            swiping.swipingDelegate = self
            swiping.swipe(cardView, .left)
        }
    }
    @IBAction func likeButtonTapped(_ sender: Any) {
        if let swiping = cardView.gestureRecognizers?.first as? Swiping{
            swiping.swipingDelegate = self
            swiping.swipe(cardView, .right)
        }

    }
    
    func updateCard(){
        guard let businesses = businesses else{ return }
        if index >= businesses.count{
            if businessesModel.likedBusinesses.count != 0{
                selectRandomBusiness()
                
                likeButton.isEnabled = false
                dislikeButton.isEnabled = false
            }
            
            
            cardView.isHidden = true
            noMoreBusinessLabel.isHidden = false
            return
        }
        

        let business = businesses[index]
        self.currentBusiness = business
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
        
        DispatchQueue.main.async{
            self.nameLabel.text = business.name
            self.imageView.image = UIImage(data: imageData!)
            
           
            self.categoryLabel.text = business.categories.first?.name
            
            self.addressLabel.text = business.location.address.joined(separator: " ")
            self.numberReviewsLabel.text = String(business.reviewCount) + " Reviews"
            
            self.businessURL = business.url
            self.phoneNumberLabel.text = business.phone
            
            if let image = self.businessesModel.getBusinessImage(business){
                self.ratingImageView.image = image
            }
            
            
            
        }
        
        
        
    }
    
    @objc func yelpImageTapped(sender: UITapGestureRecognizer){
        if let url = businessURL{
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchData()
    }
    
    
    
   
}

