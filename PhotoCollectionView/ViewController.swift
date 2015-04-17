//
//  ViewController.swift
//  PhotoCollectionView
//
//  Created by Yuan Gao on 9/21/14.
//  Copyright (c) 2014 WonderHow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var view1 : PhotoCollevtionView?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        var image1 = UIImage(named: "wide")
        var image2 = UIImage(named: "square")
        var image3 = UIImage(named: "high")
        var image4 = UIImage(named: "pic4")
        var image5 = UIImage(named: "pic5")
        var image6 = UIImage(named: "pic6")
        var image7 = UIImage(named: "pic7")
        var array = NSArray(array: [image1!, image2!, image3!, image4!, image5!])
        view1 = PhotoCollevtionView(outerFrame: self.view.frame, photoArray: array)
        self.view.addSubview(view1!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view1!.frame = self.view.frame
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

