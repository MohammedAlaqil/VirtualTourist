//
//  PhotosViewController.swift
//  VirtualTourist
//
//  Created by M7md on 21/06/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//


import UIKit
import MapKit
import CoreData

class PhotosViewController : UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , NSFetchedResultsControllerDelegate {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionBottom : UIBarButtonItem!
    @IBOutlet weak var labelText : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var fetchedResultsController : NSFetchedResultsController<Photo>!
    var pin : Pin!
    var pageNumber = 1
    var isDeletingEverything = false
    
    var context : NSManagedObjectContext {
        return DataController.sharedInstance.viewContext
    }
    
    var doWeHavePhotos: Bool {
        return ( fetchedResultsController.fetchedObjects?.count ?? 0 ) != 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest : NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false) ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
                updateUI(processing : false)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    @IBAction func bottomButtonTapped(_ sender: Any) {
        updateUI(processing : true)
        if doWeHavePhotos {
            isDeletingEverything = true
            for photo in fetchedResultsController.fetchedObjects! {
                context.delete(photo)
            }
            try? context.save()
            isDeletingEverything = false
        }
        FlickerAPI.getPhotosURL(with: pin.coordinate, pageNumber: pageNumber) { (urls, error, message) in
            DispatchQueue.main.async {
                self.updateUI(processing : false)
                
                guard (error == nil) && (message == nil) else {
                    self.alert(title: "Error", message: error?.localizedDescription ?? message!)
                    return
                }
                
                guard let urls = urls , !urls.isEmpty else {
                    self.labelText.isHidden = false
                    return
                }
                for url in urls {
                    let photo = Photo(context: self.context)
                    photo.imageURL = url
                    photo.pin = self.pin
                }
                try? self.context.save()
            }
        }
        pageNumber += 1
    }
    func updateUI (processing: Bool ){
        collectionView.isUserInteractionEnabled = !processing
        if processing {
            newCollectionBottom.title = ""
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            newCollectionBottom.title = "New Collection"
        }
    }
    
   override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! CollectionCell
        let photo = fetchedResultsController.object(at: indexPath)
        cell.imageCell.setPhoto(photo)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        context.delete(photo)
        try? context.save()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-20) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = indexPath , type == .delete && !isDeletingEverything{
            collectionView.deleteItems(at: [indexPath])
            return
        }
        if let indexPath = indexPath , type == .insert {
            collectionView.insertItems(at: [indexPath])
            return
        }
        if let newIndexPath = newIndexPath , let oldIndexPath = indexPath , type == .move {
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            return
        }
        if type != .update {
            collectionView.reloadData()
        }
    }
    
    // New Method for the last Project
    @IBAction func ClearButtonTabbed(_ sender: Any) {
        
        if doWeHavePhotos {
            isDeletingEverything = true
            for photo in fetchedResultsController.fetchedObjects! {
                context.delete(photo)
            }
            try? context.save()
            isDeletingEverything = false
          
        }
    }
    
    
}
