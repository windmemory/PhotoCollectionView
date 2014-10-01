//
//  PhotoCollectionController.swift
//  PhotoCollectionView
//
//  Created by Yuan Gao on 9/21/14.
//  Copyright (c) 2014 WonderHow. All rights reserved.
//

import UIKit

class PhotoCollevtionView: UIView, UIScrollViewDelegate {
    private let halfPhotoGap : CGFloat = 10.0
    private let photoGap : CGFloat = 20.0
    var rotatable = true
    var currentPhoto : Int
    var photosArray = NSArray()
    private var currentViewNumber = 1
    private var imageViewArray : NSArray
    private var contentView = UIScrollView()
    private var userDragged = false
    
    init(outerFrame: CGRect, photoArray: NSArray, currentNumber: Int = 1) {
        photosArray = photoArray
        currentPhoto = currentNumber
        
        //initialize the photosArray, if the photo collection has more than 3 photos, then alloc with three uiimageView
        if (photosArray.count == 1){
            imageViewArray = NSArray(array: [ZoomablePhotoView(picture: photosArray[0] as UIImage, frame: outerFrame)])
            currentViewNumber = 0
            (imageViewArray[0] as ZoomablePhotoView).pageNumber = 0
        }else if (photosArray.count == 2){
            imageViewArray = NSArray(array: [ZoomablePhotoView(picture: photosArray[0] as UIImage, frame: outerFrame), ZoomablePhotoView(picture: photosArray[1] as UIImage, frame: outerFrame)])
            currentViewNumber = currentPhoto
            (imageViewArray[0] as ZoomablePhotoView).pageNumber = 0
            (imageViewArray[1] as ZoomablePhotoView).pageNumber = 1
        }else{
            if (currentNumber == 0){
                imageViewArray = NSArray(array: [ZoomablePhotoView(picture: photosArray[0] as UIImage, frame: outerFrame), ZoomablePhotoView(picture: photosArray[1] as UIImage, frame: outerFrame), ZoomablePhotoView(picture: photosArray[2] as UIImage, frame: outerFrame)])
                currentViewNumber = 0
                for i in 0...2{
                    (imageViewArray[i] as ZoomablePhotoView).pageNumber = i
                }
            }else if (currentNumber == photosArray.count - 1){
                imageViewArray = NSArray(array: [ZoomablePhotoView(picture: photosArray[currentPhoto - 2] as UIImage, frame: outerFrame), ZoomablePhotoView(picture: photosArray[currentPhoto - 1] as UIImage, frame: outerFrame), ZoomablePhotoView(picture: photosArray[currentPhoto] as UIImage, frame: outerFrame)])
                currentViewNumber = 2
                for i in 0...2{
                    (imageViewArray[(currentPhoto - 2 + i) % 3] as ZoomablePhotoView).pageNumber = currentPhoto - 2 + i
                }
            }else{
                imageViewArray = NSArray(array: [ZoomablePhotoView(picture: photosArray[currentPhoto - 1] as UIImage, frame: outerFrame), ZoomablePhotoView(picture: photosArray[currentPhoto] as UIImage, frame: outerFrame), ZoomablePhotoView(picture: photosArray[currentPhoto + 1] as UIImage, frame: outerFrame)])
                currentViewNumber = 1
                for i in 0...2{
                    (imageViewArray[(currentPhoto - 1 + i) % 3] as ZoomablePhotoView).pageNumber = currentPhoto - 1 + i
                }
            }
        }
        
        super.init(frame: outerFrame)
        frame = outerFrame
        
        contentView.frame = CGRect(x: -halfPhotoGap, y: 0, width: self.frame.width + photoGap, height: self.frame.height)
        self.addSubview(contentView)
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addConstraints([
            NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)])
        contentView.pagingEnabled = true
        contentView.delegate = self
        
        for i in 0...(imageViewArray.count - 1){
            contentView.addSubview(imageViewArray[i] as UIView)
            (imageViewArray[i] as ZoomablePhotoView).frame.origin = CGPoint(x: (CGFloat)((imageViewArray[i] as ZoomablePhotoView).pageNumber) * contentView.frame.width + halfPhotoGap, y: 0)
            (imageViewArray[i] as ZoomablePhotoView).userInteractionEnabled = true
        }
        
        contentView.contentSize = CGSize(width: contentView.frame.width * (CGFloat)(photosArray.count), height: contentView.frame.height)
        contentView.contentOffset = CGPoint(x: (CGFloat)(currentPhoto) * contentView.frame.width, y: 0)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        userDragged = false
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        userDragged = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (userDragged){
            if contentView.contentOffset.x > (0.7 * contentView.frame.width + imageViewArray[currentViewNumber].frame.origin.x){
                currentViewNumber = (currentViewNumber + 1) % 3
                currentPhoto++
                if currentPhoto < photosArray.count - 1{
                    (imageViewArray[(currentViewNumber + 1) % 3] as ZoomablePhotoView).pageNumber = (currentPhoto + 1)
                    (imageViewArray[(currentViewNumber + 1) % 3] as ZoomablePhotoView).assignPhoto(picture: photosArray[currentPhoto + 1] as UIImage)
                    (imageViewArray[(currentViewNumber + 1) % 3] as ZoomablePhotoView).frame.origin = CGPoint(x: (CGFloat)(currentPhoto + 1) * contentView.frame.width + halfPhotoGap, y: 0)
                }
                
            }else if contentView.contentOffset.x < (imageViewArray[currentViewNumber].frame.origin.x - 0.7 * contentView.frame.width){
                currentViewNumber = (currentViewNumber + 2) % 3
                currentPhoto--
                if currentPhoto > 0{
                    (imageViewArray[(currentViewNumber + 2) % 3] as ZoomablePhotoView).pageNumber = (currentPhoto - 1)
                    (imageViewArray[(currentViewNumber + 2) % 3] as ZoomablePhotoView).assignPhoto(picture: photosArray[currentPhoto - 1] as UIImage)
                    (imageViewArray[(currentViewNumber + 2) % 3] as ZoomablePhotoView).frame.origin = CGPoint(x: (CGFloat)(currentPhoto - 1) * contentView.frame.width + halfPhotoGap, y: 0)
                }
                
            }
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0...(imageViewArray.count - 1){
            (imageViewArray[i] as ZoomablePhotoView).frame = CGRect(x: (CGFloat)((imageViewArray[i] as ZoomablePhotoView).pageNumber) * contentView.frame.width + halfPhotoGap, y: 0, width: self.frame.width, height: self.frame.height)
        }
        contentView.contentSize = CGSize(width: contentView.frame.width * (CGFloat)(photosArray.count), height: contentView.frame.height)
        contentView.contentOffset = CGPoint(x: (CGFloat)(currentPhoto) * contentView.frame.width, y: 0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}