//
//  ViewNextToTheSidMenuViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-03.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class MealOfDayViewController: UIViewController {
    @IBOutlet weak var mealOfTheDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var fooodImageView: UIImageView!
    @IBOutlet weak var recipeButton: UIButton!
    
    private let goToDish = "goToDish"
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("dishImages")
    }
    
    var mealOfTheDayName: String = ""
    var mealOfTheDayID: String = ""
    var dateOfTheDay: String = ""
    
    var dishesID: [String] = []
    
    var db: Firestore!
    var dishes = Dishes()
    var dishId: String?
    
    override func viewWillAppear(_ animated: Bool) {
        db = Firestore.firestore()
        getWeeklyMenuFromFireStore()
        getDishesIdFromFirestore()
        setRadiusBorderColorAndFontOnLabelsViewsAndButtons()
        
        // Om det inte finns några maträtter att hämta från databasaen, gå direkt till DishesViewController så att användaren kan börja lägga till maträtter.
        if dishesID == [""] {
            goToDishesViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setRadiusBorderColorAndFontOnLabelsViewsAndButtons() {
        mealOfTheDayLabel.textColor = Theme.current.textColorForLabels
        dateLabel.textColor = Theme.current.textColorForLabels
        foodNameLabel.textColor = Theme.current.textColorForLabels
        fooodImageView.layer.masksToBounds = true
        fooodImageView.layer.cornerRadius = 12
        fooodImageView.layer.borderWidth = 2
        fooodImageView.layer.borderColor = Theme.current.colorForBorder.cgColor
        recipeButton.layer.cornerRadius = 15
        recipeButton.layer.borderWidth = 2
        recipeButton.layer.borderColor = Theme.current.colorForBorder.cgColor
        recipeButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 17)
        recipeButton.setTitleColor(Theme.current.colorForBorder, for: .normal)
        
    }
    
    func downloadImageFromStorage() {
        let downloadImageRef = imageReference.child(dishId ?? "No dishId")
        
        if downloadImageRef.name == dishId {
            let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
                if let error = error {
                    print("Error downloading \(error)")
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        self.fooodImageView.image = image
                    }
                    print(error ?? "No error")
                }
            }
                        downloadTask.observe(.progress) { (snapshot) in
                            //print(snapshot.progress ?? "No more progress")
                        }
            //            downloadTask.resume()
        }
    }
    
    // Hämtar maträtter och sparar deras id i en array (dishesID).
    func getDishesIdFromFirestore() {
        db.collection("dishes").getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                for document in snapshot.documents {
                    let dish = Dish(snapshot: document)
                    self.dishesID.append(dish.dishID)
                    self.db.collection("dishes").document(document.documentID).collection("ingredients").getDocuments(){
                        (querySnapshot, error) in
                        
                        for document in (querySnapshot?.documents)!{
                            let ing = Ingredient(snapshot: document)
                            
                            dish.add(ingredient: ing)
                        }
                    }
                    if self.dishes.add(dish: dish) == true {
                    }
                }
            }
        }
    }
    
    // Hämtar data från veckomenyn för att sedan jämföra dagens datum med datum i veckomenyn och visa rätt maträtt,
    // om menyn inte har en maträtt då ska selectRandomDishController visas
    func getWeeklyMenuFromFireStore() {
        db.collection("weeklyMenu").getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                
                for document in snapshot.documents {
                    let weeklyMenu = DishAndDate(snapshot: document)
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .long
                    let dateToString = dateFormatter.string(from: date)
                    
                    let dateFromDish = weeklyMenu.date
                    let dateFormatterDish = DateFormatter()
                    dateFormatterDish.dateStyle = .long
                    let dateFromDishToString = dateFormatterDish.string(from: dateFromDish)
                    
                    if dateToString == dateFromDishToString {
                        self.mealOfTheDayName = (weeklyMenu.dishName)
                        self.mealOfTheDayID = (weeklyMenu.idFromDish)
                        self.dishId = weeklyMenu.idFromDish
                        self.downloadImageFromStorage()
                    }
                }
            }
            self.foodNameLabel.text = self.mealOfTheDayName
            
            let date1 = Date()
            let dateFormatter1 = DateFormatter()
            dateFormatter1.locale = NSLocale(localeIdentifier: "en_US") as Locale //"sv_SE"
            dateFormatter1.dateFormat = "EEEE dd/MM"
            let outputDate = dateFormatter1.string(from: date1)
            
            self.dateOfTheDay = outputDate
            
            self.dateLabel.text = self.dateOfTheDay
            
            if self.mealOfTheDayName == "" {
                self.goToSelectRandomDish()
            }
        }
    }
    
    func goToDishesViewController() {
        if let dishes = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dishesView") as? DishesViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            dishes.modalTransitionStyle = modalStyle
            self.present(dishes, animated: true, completion: nil)
        }
    }
    
    func goToSelectRandomDish() {
        if let selectRandomDish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectRandomWeekId") as? SelectRandomDishesViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            selectRandomDish.modalTransitionStyle = modalStyle
            self.present(selectRandomDish, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToDish {
            let destVC = segue.destination as? ShowDishViewController
            
            for dish in dishes.dishes  {
                if mealOfTheDayID == dish.dishID {
                    
                    destVC!.dish = dish
                    
                    destVC!.dishId = dish.dishID
                }
            }
        }
    }
    
    func alertMessage(titel: String) {
        let alert = UIAlertController(title: titel, message: "Pleace try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
}
