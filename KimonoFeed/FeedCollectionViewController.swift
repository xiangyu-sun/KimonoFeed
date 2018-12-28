//
//  FeedCollectionViewController.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 12/22/18.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImageCollectionViewCell"

class FeedCollectionViewController: UICollectionViewController {
    
    @objc let feedViewModel = FeedViewModel()
    
    var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observation = observe(\.feedViewModel.result, options:  [.old, .new]) {[unowned self] (object, change) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        feedViewModel.reload()
    }
    
    private func config(cell: ImageCollectionViewCell, with photo: BriefPhotoInfo) {
        cell.titleLabel.text = photo.title
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedViewModel.result?.photos.photo.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if  let imageCell = cell as? ImageCollectionViewCell,
        let photo = feedViewModel.photoAt(indexPath: indexPath){
            config(cell: imageCell, with: photo)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let imageCell = cell as? ImageCollectionViewCell,
            let photo = feedViewModel.photoAt(indexPath: indexPath)
            else {
                return
        }
        imageCell.pullImageAndInfomation(photo: photo)

    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
