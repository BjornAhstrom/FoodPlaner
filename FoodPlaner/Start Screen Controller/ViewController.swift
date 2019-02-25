//
//  ViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-02-25.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explanatoryTextView: UITextView!
    @IBOutlet weak var pageStatusBar: UIPageControl!
    private var image = [UIImage]()
    var i = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        image = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3")] as! [UIImage]
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "1")
        explanatoryTextView.text! = "First side"
        
        swipeLeftAndRight()
    }
    
    func swipeLeftAndRight() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureLeft(sender:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureRight(sender:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipeGestureLeft(sender: UIGestureRecognizer) {
        
        if i < image.count-1 {
            i += 1
            imageView.image = image[i]
        }
        
        if i == 1 {
            explanatoryTextView.text! = "Second side"
            pageStatusBar.currentPage = 1
        }
        
        if i == 2 {
            explanatoryTextView.text! = "third side"
            pageStatusBar.currentPage = 2
        }
    }
    
    @objc func swipeGestureRight(sender: UIGestureRecognizer) {
        
        if i <= image.count-1 {
            i -= 1
            imageView.image = image[i]
        }
        
        if i == 0 {
            explanatoryTextView.text! = "First side"
            pageStatusBar.currentPage = 0
        }
        
        if i == 1 {
            explanatoryTextView.text! = "Second side"
            pageStatusBar.currentPage = 1
        }
        
        if i == 2 {
            explanatoryTextView.text! = "third side"
            pageStatusBar.currentPage = 2
        }
    }
}

