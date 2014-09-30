# PhotoCollectionView

This view helps you display your photos and developed using swift. It's almost like the Photo app in iOS. You can zoom every single photo and display as many photos as you want. Yet I am still working on this project, but I have already relized the basic functions.

###Demo

[Click here to see the demo](http://youtu.be/3_liToyJqXc)

###How to use
Copy `PhotoCollectionView.swift` and `ZoomablePhotoView.swift` to your project.

You need three arguments to initialize this view. 

1. frame for this view
2. an array contains all the photo you want to display in the view
3. (optional)the number you want to  display initially

Create an instance of `PhotoCollectionView` like this:

```swift
var image1 = UIImage(named: "pic1")
var image2 = UIImage(named: "pic2")
var image3 = UIImage(named: "pic3")
var image4 = UIImage(named: "pic4")
var image5 = UIImage(named: "pic5")
var photoArray = NSArray(array: [image1,image2,image3,image4,image5])
var myPhotoCollectionView = PhotoCollevtionView(outerFrame: self.view.frame, photoArray: array)
//or you can initialize it like this:
//var myPhotoCollectionView = PhotoCollevtionView(outerFrame: self.view.frame, photoArray: array, currentNumber: 3)
```

Then add this view to your view in which you want to display these photos.

