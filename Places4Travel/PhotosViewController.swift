//
//  FirstViewController.swift
//  Places4Travel
//
//  Created by Brick Bai on 2017-02-27.
//  Copyright © 2017 Brick Bai. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces


class PhotosViewController: UICollectionViewController {
	
	@IBOutlet var PhotosView: UICollectionView!
	
	
	let manager = CLLocationManager()
	var currentPlaceID:String? = nil;
	let photocellindentifer = "photo"
	
	var imageArray:[UIImage] = []
	
	required init?(coder aDecoder: NSCoder) {
		PhotosView.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//get location service permision
		if CLLocationManager.authorizationStatus() == .notDetermined {
			self.manager.requestWhenInUseAuthorization()
		}
		
		//get currentPlaceID
		GMSPlacesClient.shared().currentPlace(callback: { (placeLikelihoodList, error) -> Void in
			if let error = error {
				print("Pick Place error: \(error.localizedDescription)")
				return
			}
			
			if let placeLikelihoodList = placeLikelihoodList {
				if let likelihood = placeLikelihoodList.likelihoods.first{
					self.currentPlaceID = likelihood.place.placeID
				}
			}
		})
		
		//get photoMetadata using currentPlaceID
		if self.currentPlaceID != nil {
			loadPhotosForPlace(placeID: self.currentPlaceID!)
		}
		
	}
	
	func loadPhotosForPlace(placeID: String) {
		GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
			if let error = error {
				// TODO: handle the error.
				print("Error: \(error.localizedDescription)")
			} else if let photos = photos {
				for result in photos.results {
					self.loadImageForMetadata(photoMetadata: result)
				}
			}
		}
	}
	
	func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
		GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
			if let error = error {
				// TODO: handle the error.
				print("Error: \(error.localizedDescription)")
			} else if let photo = photo {
				self.imageArray.append(photo)
				//...
			}
		})
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - UICollectionViewDataSource protocol
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.imageArray.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// get a reference to our storyboard cell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photocellindentifer, for: indexPath as IndexPath)
		
		// Use the outlet in our custom class to get a reference to the UILabel in the cell
		cell.imageview = imageArray[indexPath.row]
		
		return cell
	}
	
	// MARK: - UICollectionViewDelegate protocol
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// handle tap events
		print("You selected cell #\(indexPath.item)!")
	}
	
}

