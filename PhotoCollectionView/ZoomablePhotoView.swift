//
//  ZoomablePhotoView.swift
//  PhotoCollectionView
//
//  Created by Yuan Gao on 9/21/14.
//  Copyright (c) 2014 WonderHow. All rights reserved.
//

import UIKit

class ZoomablePhotoView: UIScrollView,UIScrollViewDelegate {
    
    private var imageView = UIImageView()
    private var image = UIImage()
    private var isZoomed = false
    var pageNumber : Int = 0
    init(picture assignedImage:UIImage, frame assignedFrame:CGRect){
        image = assignedImage
        imageView.image = assignedImage
        super.init(frame: assignedFrame)
        imageView.frame.size = calculatePictureSize()
//        var blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
//        blurView.frame = imageView.bounds
        
        
        setPictoCenter()
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.addSubview(imageView)
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = calculateMaximunScale()
        var tap = UITapGestureRecognizer(target: self, action: "tapZoom")
        tap.numberOfTapsRequired = 2
//        self.addSubview(blurView)
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
    }
    
    func tapZoom(){
        if isZoomed{
            self.setZoomScale(minimumZoomScale, animated: true)
            isZoomed = false
        }else{
            self.setZoomScale(maximumZoomScale, animated: true)
            isZoomed = true
        }
    }
    
    func assignPhoto(picture assignedImage:UIImage){
        image = assignedImage
        self.contentSize = CGSize(width: 0, height: 0)
        imageView.image = assignedImage
        imageView.frame.size = calculatePictureSize()
        setPictoCenter()
        self.maximumZoomScale = calculateMaximunScale()
        isZoomed = false
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
    
    private func ScreenSize() -> CGSize{
        return CGSize(width: frame.width, height: frame.height)
    }
    
    private func calculatePictureSize() -> CGSize{
        var picSize = image.size
        var screenSize = ScreenSize()
        var picRatio = picSize.width / picSize.height
        var screenRatio = screenSize.width / screenSize.height
        
        if (picRatio > screenRatio){
            return CGSize(width: screenSize.width, height: screenSize.width / picSize.width * picSize.height)
        }else{
            return CGSize(width: screenSize.height / picSize.height * picSize.width, height: screenSize.height)
        }
    }
    
    private func calculateMaximunScale() -> CGFloat{
        return image.size.width / calculatePictureSize().width
    }
    
    private func setPictoCenter(){
        var intendHorizon = (self.ScreenSize().width - imageView.frame.width ) / 2
        var intendVertical = (self.ScreenSize().height - imageView.frame.height ) / 2
        intendHorizon = intendHorizon > 0 ? intendHorizon : 0
        intendVertical = intendVertical > 0 ? intendVertical : 0
        contentInset = UIEdgeInsets(top: intendVertical, left: intendHorizon, bottom: intendVertical, right: intendHorizon)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        setPictoCenter()
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        isZoomed = true
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        if (scale == self.minimumZoomScale){
            isZoomed = false
        }
    }
    
    private func isFullScreen() -> Bool{
        if (imageView.frame.width >= self.ScreenSize().width && imageView.frame.height >= self.ScreenSize().height){
            return true
        }else{
            return false
        }
    }
    
    //--------------------need to be tested---------------------------------
    func currentPhotoPosition() -> (photo: UIImage, frame: CGRect){
        var position : CGRect
        if (self.isFullScreen()){
            position = CGRect(origin: self.contentOffset, size: imageView.frame.size)
        }else{
            position = CGRect(x: contentInset.left, y: contentInset.top, width: imageView.frame.width, height: imageView.frame.height)
        }
        return (image, position)
    }
    //--------------------need to be tested--------------------------------
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (!isZoomed){
            imageView.frame.size = calculatePictureSize()
            setPictoCenter()
            
        }
        if (!self.isFullScreen()){
            setPictoCenter()
        }else{
            self.clearContentInsets()
        }
        self.maximumZoomScale = calculateMaximunScale()
        
    }
    
    func clearContentInsets(){
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
