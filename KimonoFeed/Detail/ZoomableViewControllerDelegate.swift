//
//  ZoomableImageViewController.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 01/04/19.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import UIKit

protocol ZoomableImageViewControllerDelegate: class {
    func photoZoomViewController(_ photoZoomViewController: ZoomableImageViewController, scrollViewDidScroll scrollView: UIScrollView)
}

class ZoomableImageViewController: UIViewController {
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: ZoomableImageViewControllerDelegate?
    
    var image: UIImage!
    var index: Int = 0
    var isRotating: Bool = false
    var firstTimeLoaded: Bool = true
    
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapWith(gestureRecognizer:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        imageView.image = image
        imageView.frame = CGRect(x: imageView.frame.origin.x,
                                      y: imageView.frame.origin.y,
                                      width: image.size.width,
                                      height: image.size.height)
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        
        //Update the constraints to prevent the constraints from
        //being calculated incorrectly on certain iOS devices
        updateConstraintsForSize(view.frame.size)
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
            guard let parentVC = navigationController?.viewControllers.first as? FeedCollectionViewController else {
                return
            }
            
            //Update the ViewController's left and right local safeAreaInset variables
            //with the safeAreaInsets for this current view. These will be used to
            //update the contentInsets of the collectionView inside ViewController
            parentVC.currentLeftSafeAreaInset = view.safeAreaInsets.left
            parentVC.currentRightSafeAreaInset = view.safeAreaInsets.right
            
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        isRotating = true
    }
    
    @objc func didDoubleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        let pointInView = gestureRecognizer.location(in: imageView)
        var newZoomScale = scrollView.maximumZoomScale
        
        if scrollView.zoomScale >= newZoomScale || abs(scrollView.zoomScale - newZoomScale) <= 0.01 {
            newZoomScale = scrollView.minimumZoomScale
        }
        
        let width = scrollView.bounds.width / newZoomScale
        let height = scrollView.bounds.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    fileprivate func updateZoomScaleForSize(_ size: CGSize) {
        
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        
        //scrollView.zoomScale is only updated once when
        //the view first loads and each time the device is rotated
        if isRotating || firstTimeLoaded {
            scrollView.zoomScale = minScale
            isRotating = false
            firstTimeLoaded = false
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
        
        let contentHeight = yOffset * 2 + imageView.frame.height
        view.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: contentHeight)
    }
}

extension ZoomableImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.photoZoomViewController(self, scrollViewDidScroll: scrollView)
    }
}
