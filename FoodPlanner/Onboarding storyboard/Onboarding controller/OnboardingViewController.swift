//
//  ExplanatoryViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-02-25.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    private var image = [UIImage]()
    private var i = Int()
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explanatoryTextView: UITextView!
    @IBOutlet weak var pageStatusBar: UIPageControl!
    
    private var signInPageId: String = "signInPage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColorFontAndSizeOnButtonsAndLabels()
        disableButton()
        
        image = [UIImage(named: "MealOfTheDay"), UIImage(named: "CreateWeeklyMenu"), UIImage(named: "ShoppingList")] as! [UIImage]
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "MealOfTheDay")
        explanatoryTextView.text! = "First side"
        
        swipeLeftAndRight()
    }
    
    func setColorFontAndSizeOnButtonsAndLabels() {
        nextButton.layer.cornerRadius = 15
        nextButton.layer.borderWidth = 2
        nextButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        nextButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 15)
        nextButton.setTitleColor(Theme.current.textColor, for: .normal)
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
            explanatoryTextView.text! = "Third side"
            pageStatusBar.currentPage = 2
            enableButton()
        }
    }
    
    @objc func swipeGestureRight(sender: UIGestureRecognizer) {
        
        if i <= image.count-1 && i != 0{
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
            explanatoryTextView.text! = "Third side"
            pageStatusBar.currentPage = 2
            enableButton()
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if let loginScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: signInPageId) as? signInViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            loginScreen.modalTransitionStyle = modalStyle
            self.present(loginScreen, animated: true, completion: nil)
        }
    }
    
    func disableButton() {
        nextButton.isEnabled = false
        nextButton.isHidden = true
    }
    
    func enableButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.nextButton.isEnabled = true
            self.nextButton.isHidden = false
        }
    }
    
}

