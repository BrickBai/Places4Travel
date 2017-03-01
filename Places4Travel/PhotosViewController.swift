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
	var addressText = String()
	var placeName = String()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//get location service permision
		if CLLocationManager.authorizationStatus() == .notDetermined {
			self.manager.requestAlwaysAuthorization()
		}
		
		self.getCurrentPlacePhotos()
	}
	
	func getCurrentPlacePhotos() {
		GMSPlacesClient.shared().currentPlace(callback: { (placeLikelihoodList, error) -> Void in
			if let error = error {
				print("Pick Place error: \(error.localizedDescription)")
				return
			}
			
			if let placeLikelihoodList = placeLikelihoodList {
				if let likelihood = placeLikelihoodList.likelihoods.first{
					let place = likelihood.place
					print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
					print("Current Place address \(place.formattedAddress)")
					print("Current Place attributions \(place.attributions)")
					print("Current PlaceID \(place.placeID)")
					//get photoMetadata using currentPlaceID
					self.loadPhotosForPlace(placeID: likelihood.place.placeID)
					self.placeName = place.name
					if let address = place.formattedAddress {
						self.addressText = address
					} else {
						self.addressText = "No available address"
					}
				}
			}
		})
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
				//it's not the best place to reload
				self.collectionView?.reloadData()
			}
		})
	}
	
	// MARK: - UICollectionViewDataSource protocol
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		print("self.imageArray.count is \(self.imageArray.count)")
		return self.imageArray.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// get a reference to our storyboard cell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photocellindentifer, for: indexPath as IndexPath) as! CollectionViewCell
		
		// Use the outlet in our custom class to get a reference to the UILabel in the cell
		cell.collectionImageView.image = imageArray[indexPath.row]
		return cell
	}
	
	// MARK: - UICollectionViewDelegate protocol
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// handle tap events
		print("You selected cell #\(indexPath.item)!")
		self.performSegue(withIdentifier: "showImage", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showImage" {
			let indexPaths = self.PhotosView.indexPathsForSelectedItems!
			let indexPath = indexPaths[0] as NSIndexPath
			
			let vc = segue.destination as! ClickViewController
			
			vc.image = self.imageArray[indexPath.row]
			vc.labelText = self.addressText
			vc.navTitle = self.placeName
		}
	}
	
}

