# KimonoFeed
### PG-13
[![Build Status](https://travis-ci.com/xiangyu-sun/KimonoFeed.svg?branch=master)](https://travis-ci.com/xiangyu-sun/KimonoFeed)

## Overview
The app search the keyword "kimono" on flickr, and shows the search result on collection view with a custom layout. Tap on the photo an Apple Photos app like effect allows you to zoom in zoom out, and drag to dismiss. 

## Get Started
Just run it!

## Costomized Collection View Layout
FeedCollectionViewController uses FancyLayout for creating a mosiac like layout. 
For every item in the collection view:
- Prepare the attributes.
- Store attributes in the cachedAttributes array.
- Combine contentBounds with attributes.frame.

## UIViewControllerInteractiveTransitioning

PageViewControllerContainer action as a wrapper around UIPageViewController contain the logic that handles zoom and panToexit.
While UIPageViewController can use mutiple ZoomableImageViewControllers if needed, in this project only one has been used. 
