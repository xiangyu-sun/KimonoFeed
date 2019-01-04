//
//  ZoomableViewController.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 01/04/19.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import UIKit

protocol ZoomableViewControllerDelegate: class {
    func photoZoomViewController(_ photoZoomViewController: ZoomableViewController, scrollViewDidScroll scrollView: UIScrollView)
}

class ZoomableViewController: UIViewController {
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: ZoomableViewControllerDelegate?
    
    var image: UIImage!
    var index: Int = 0
    var isRotating: Bool = false
    var firstTimeLoaded: Bool = true
    
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapWith(gestureRecognizer:)))
        self.doubleTapGestureRecognizer.numberOfTapsRequired = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        if #available(iOS 11, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.imageView.image = self.image
        self.imageView.frame = CGRect(x: self.imageView.frame.origin.x,
                                      y: self.imageView.frame.origin.y,
                                      width: self.image.size.width,
                                      height: self.image.size.height)
        self.view.addGestureRecognizer(self.doubleTapGestureRecognizer)
        
        //Update the constraints to prevent the constraints from
        //being calculated incorrectly on certain iOS devices
        self.updateConstraintsForSize(self.view.frame.size)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoomScaleForSize(view.bounds.size)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        
        //When this view's safeAreaInsets change, propagate this information
        //to the previous ViewController so the collectionView contentInsets
        //can be updated accordingly. This is necessary in order to properly
        //calculate the frame position for the dismiss (swipe down) animation

        if #available(iOS 11, *) {
            
            //Get the parent view controller (ViewController) from the navigation controller
            guard let parentVC = self.navigationController?.viewControllers.first as? FeedCollectionViewController else {
                return
            }
            
            //Update the ViewController's left and right local safeAreaInset variables
            //with the safeAreaInsets for this current view. These will be used to
            //update the contentInsets of the collectionView inside ViewController
            parentVC.currentLeftSafeAreaInset = self.view.safeAreaInsets.left
            parentVC.currentRightSafeAreaInset = self.view.safeAreaInsets.right
            
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.isRotating = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didDoubleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        let pointInView = gestureRecognizer.location(in: self.imageView)
        var newZoomScale = self.scrollView.maximumZoomScale
        
        if self.scrollView.zoomScale >= newZoomScale || abs(self.scrollView.zoomScale - newZoomScale) <= 0.01 {
            newZoomScale = self.scrollView.minimumZoomScale
        }
        
        let width = self.scrollView.bounds.width / newZoomScale
        let height = self.scrollView.bounds.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        self.scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    fileprivate func updateZoomScaleForSize(_ size: CGSize) {
        
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        
        //scrollView.zoomScale is only updated once when
        //the view first loads and each time the device is rotated
        if self.isRotating || self.firstTimeLoaded {
            scrollView.zoomScale = minScale
            self.isRotating = false
            self.firstTimeLoaded = false
        }
        
        scrollView.maximumZoomScale = minScale * 4
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        let contentHeight = yOffset * 2 + self.imageView.frame.height
        view.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: contentHeight)
    }
}

extension ZoomableViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(self.view.bounds.size)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.photoZoomViewController(self, scrollViewDidScroll: scrollView)
    }
}