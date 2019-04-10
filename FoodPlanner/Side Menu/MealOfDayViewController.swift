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
    
   // var toDaysDateToString: String = ""
   // var dateFromWeeklyMenuDishToString: String = ""
    var mealOfTheDayName: String?
    var mealOfTheDayID: String?
    var dateOfTheDay: String?
    
    var dishesID: [String] = []
    
    var db: Firestore!
    var auth: Auth!
    var dishes = Dishes()
    var dishId: String?
    
    override func viewWillAppear(_ animated: Bool) {
        db = Firestore.firestore()
        auth = Auth.auth()
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
        mealOfTheDayLabel.textColor = Theme.current.mealOfTheDayLabelTextColor
        mealOfTheDayLabel.font = Theme.current.mealOfTheDayLabelFont
        dateLabel.textColor = Theme.current.dateLabelTextColor
        dateLabel.font = Theme.current.dateLabelFont
        foodNameLabel.textColor = Theme.current.foodNameLabelTextColor
        foodNameLabel.font = Theme.current.foodNameLabelFont
        fooodImageView.layer.masksToBounds = true
        fooodImageView.layer.cornerRadius = 12
        fooodImageView.layer.borderWidth = 2
        fooodImageView.layer.borderColor = Theme.current.colorForBorder.cgColor
        recipeButton.layer.cornerRadius = 15
        recipeButton.layer.borderWidth = 1
        recipeButton.layer.borderColor = Theme.current.recipeButtonBorderColor.cgColor
        recipeButton.titleLabel?.font = Theme.current.recipeButtonFont
        recipeButton.setTitleColor(Theme.current.recipeButtonTextColor, for: .normal)
        recipeButton.backgroundColor = Theme.current.recipeButtonBackgroundColor
        view.backgroundColor = Theme.current.backgroundColorMealOfTheDay
        
        navigationController?.navigationBar.barTintColor = Theme.current.backgroundColorInDishesView
        navigationController?.navigationBar.tintColor = Theme.current.navigationbarTextColor
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.current.navigationbarTextColor]
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
        }
    }
    
    // Hämtar maträtter och sparar deras id i en array (dishesID).
    func getDishesIdFromFirestore() {
        let uid = auth.currentUser
        guard let userId = uid?.uid else { return }
        
        db.collection("users").document(userId).collection("dishes").getDocuments() {
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
                    self.db.collection("users").document(userId).collection("dishes").document(document.documentID).collection("ingredients").getDocuments(){
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
        let uid = auth.currentUser
        guard let userId = uid?.uid else { return }
        
        db.collection("users").document(userId).collection("weeklyMenu").order(by: "date", descending: false).getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let snapshot = querySnapshot else {
                    
                    
                    self.goToSelectRandomDish()
                    return
                }
                let todayDate = Date()
                
                var mealOfToday : DishAndDate?
                var outputDate: String = ""
                
                for document in snapshot.documents {
                    let weeklyMenu = DishAndDate(snapshot: document)

                    let dateFromDish = weeklyMenu.date
                    
                    let date = dateFromDish
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale //"sv_SE"
                    dateFormatter.dateFormat = "EEEE dd/MM"
                    outputDate = dateFormatter.string(from: date)
                    
                    let order = Calendar.current.compare(todayDate, to: dateFromDish, toGranularity: .day)
                    
                    if order == .orderedSame {
                        mealOfToday = weeklyMenu
                        self.dateLabel.text = outputDate
                        break
                    }
                    if order == .orderedAscending {
                        print("\(todayDate) < \(dateFromDish) ")
                        mealOfToday = weeklyMenu
                        self.dateLabel.text = "Start date: \(outputDate)"
                        break
                    }
                }
                self.mealOfTheDayName = mealOfToday?.dishName ?? "No meal"
                self.mealOfTheDayID = mealOfToday?.idFromDish ?? ""
                self.dishId = mealOfToday?.idFromDish ?? ""
                
                self.downloadImageFromStorage()
            }
            self.foodNameLabel.text = self.mealOfTheDayName
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
}
