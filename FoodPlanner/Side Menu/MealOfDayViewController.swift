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
    private let dishesViewId = "dishesView"
    private let SelectRandomWeekId = "SelectRandomWeekId"
    
    var mealOfTheDayName: String?
    var mealOfTheDayID: String?
    var dateOfTheDay: String?
    
    var dishesID: [String] = []
    
    var db: Firestore!
    var auth: Auth!
    var users: [User] = []
    var invites: [Invite] = []
    var dishId: String?
    var userID: String = ""
    var userIdFromFamilyAccount: [String] = []
    var ownerFamilyAccountId: String = ""
    var theDaysDate: String = ""
    
    var imageReference: StorageReference?
    let cache = NSCache<NSString, UIImage>()
    
    override func viewWillAppear(_ animated: Bool) {
        db = Firestore.firestore()
        auth = Auth.auth()
        
        let todayDate = dateFormatter(toDayDate: Date())
        dateLabel.text = todayDate
        
        getFamilyAccountFromFirestore()
        fooodImageView.image = UIImage(named: "Lasagne")
        foodNameLabel.text = "\(NSLocalizedString("noMeal", comment: ""))"
        
        setRadiusBorderColorAndFontOnLabelsViewsAndButtons()
        ifUserGetAnInviteThenShowPopup()
        
        // Om det inte finns några maträtter att hämta från databasen, gå direkt till DishesViewController så att användaren kan börja lägga till maträtter.
//        print("!!!!!!!!!!!!!!!!!!!1")
//        if dishesID == [""] {
//
//            goToDishesViewController()
//        }
        //someAlertMessage()
       
        
        // PRIO: Spara bild till fil så att bilden inte behös hämtas varje gång MealOfTheDayControllern visas.
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func someAlertMessage() {
        // 1: Om användaren har maträtter och veckomenyn är tom, då ska användaren skickas till SelectRandomDishesController eller om det ska koma upp ett medlande som talar om att det inte finns någon meny skapad ännu.
        if Dishes.instance.dishes.count != 0 && mealOfTheDayID == "" {
            self.alertMessage(titel: "Din veckomeny är tom!", message: "Gå till (Skapa en vecko meny) och skapa din nya veckans meny")
        }
        
        // 2: Om Användaren är helt ny och inte har några maträtter då ska användaren få upp ett medelande som talar om för den att lägga till maträtter.
        if Dishes.instance.dishes.count == 0 {
            self.alertMessage(titel: "Du har inga maträtter!", message: "Gå till (Mina recept) och lägg till några maträtter!")
        }
        
        // 3:
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
        
//        navigationController?.navigationBar.barTintColor = Theme.current.backgroundColorInDishesView
//        navigationController?.navigationBar.tintColor = Theme.current.navigationbarTextColor
//        navigationController?.navigationBar.barStyle = .default
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.current.navigationbarTextColor]
    }
    
    func getFamilyAccountFromFirestore() {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).addSnapshotListener() {
            (document, error) in
            
            if let error = error {
                print("Error getting document \(error)")
            } else {
                guard let doc = document else { return }
                
                guard let famAccount = doc.data()?["familyAccount"] as? String else { return }
                
                let famAccountId = famAccount
                self.ownerFamilyAccountId = famAccountId
                
                self.userIdFromFamilyAccount = []
                self.db.collection("familyAccounts").document(famAccountId).collection("members").addSnapshotListener() {
                    (snapshot, error) in
                    
                    if let error = error {
                        print("Error getting document \(error.localizedDescription)")
                    } else {
                        guard let snapDoc = snapshot?.documents else { return }
                        
                        for document in snapDoc {
                            
                            self.userIdFromFamilyAccount.append(document.documentID)
                        }
                        self.getWeeklyMenuFromFireStore()
                        self.getDishesIdFromFirestore()
                    }
                }
            }
        }
    }
    
    // Hämtar maträtter och sparar deras id i en array (dishesID).
    func getDishesIdFromFirestore() {
        for userID in userIdFromFamilyAccount {
            db.collection("users").document(userID).collection("dishes").addSnapshotListener() {
                (querySnapshot, error) in
                
                if let error = error {
                    print("Error getting document, \(error.localizedDescription)")
                    
                } else {
                    guard let snapshot = querySnapshot else {
                        return
                    }
                    for document in snapshot.documents {
                        let dish = Dish(snapshot: document)
                        self.dishesID.append(dish.dishID)
                        self.db.collection("users").document(userID).collection("dishes").document(document.documentID).collection("ingredients").addSnapshotListener() {
                            (querySnapshot, error) in
                            
                            guard let snapDoc = querySnapshot?.documents else { return }
                            
                            for document in snapDoc {
                                let ing = Ingredient(snapshot: document)
                                
                                dish.add(ingredient: ing)
                            }
                        }
                        _ = Dishes.instance.add(dish: dish)
                    }
                }
            }
        }
    }
    
    // Hämtar data från veckomenyn för att sedan jämföra dagens datum med datum i veckomenyn och visa rätt maträtt,
    // om menyn inte har en maträtt då ska selectRandomDishController visas
    func getWeeklyMenuFromFireStore() {
        db.collection("familyAccounts").document(self.ownerFamilyAccountId).collection("weeklyMenu").order(by: "date", descending: false).addSnapshotListener() {
            (querySnapshot, error) in
            
            if let error = error {
                print("Error getting document \(error.localizedDescription)")
            } else {
                guard let snapshot = querySnapshot else {
                    
                    self.goToSelectRandomDish()
                    return
                }
                let todayDate = Date()
                
                var mealOfToday : DishAndDate?
                
                for document in snapshot.documents {
                    let weeklyMenu = DishAndDate(snapshot: document)

                    let dateFromDish = weeklyMenu.date
                    
                    let outputDate = self.dateFormatter(toDayDate: dateFromDish)
                    
                    let order = Calendar.current.compare(todayDate, to: dateFromDish, toGranularity: .day)
                    
                    if order == .orderedSame {
                        mealOfToday = weeklyMenu
                        self.dateLabel.text = outputDate
                        break
                    }
                    if order == .orderedAscending {
                        mealOfToday = weeklyMenu
                        self.dateLabel.text = "\(NSLocalizedString("StartDate", comment: "")) \(outputDate)"
                        break
                    }
                }
                self.mealOfTheDayName = mealOfToday?.dishName ?? "\(NSLocalizedString("noMeal", comment: ""))"
                self.mealOfTheDayID = mealOfToday?.idFromDish ?? ""
                self.dishId = mealOfToday?.idFromDish ?? ""
                
                for usersId in self.userIdFromFamilyAccount {
                    self.imageReference = Storage.storage().reference().child("usersImages").child(usersId)
                     // Ska inte loopa igenom bilderna
                    self.fooodImageView.downloadImageFromStorage(dishId: self.dishId ?? "No dishId", imageReference: self.imageReference)
                }
            }
            self.foodNameLabel.text = self.mealOfTheDayName
        }
    }
    
    func dateFormatter(toDayDate: Date) -> String {
        var outputDate: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "\(NSLocalizedString("dateLanguageFormatter", comment: ""))") as Locale
        dateFormatter.dateFormat = "EEEE dd/MM"
        outputDate = dateFormatter.string(from: toDayDate)
        
        return outputDate
    }
    
    func goToDishesViewController() {
        if let dishes = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: dishesViewId) as? DishesViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            dishes.modalTransitionStyle = modalStyle
            self.present(dishes, animated: true, completion: nil)
        }
    }
    
    func goToSelectRandomDish() {
        if let selectRandomDish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SelectRandomWeekId) as? SelectRandomDishesViewController {
            
            let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
            selectRandomDish.modalTransitionStyle = modalStyle
            self.present(selectRandomDish, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToDish {
            guard let destVC = segue.destination as? ShowDishViewController else { return }
            
            for dish in Dishes.instance.dishes  {
                if mealOfTheDayID == dish.dishID {
                    
                    destVC.dish = dish
                    
                    destVC.dishId = dish.dishID
                }
            }
        }
    }
    
    func ifUserGetAnInviteThenShowPopup() {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("invites").addSnapshotListener() {
            (snapshot, error) in
            
            if let error = error {
                print("No users \(error)")
            } else {
                
                guard let snapDoc = snapshot?.documents else { return }
                
                for document in snapDoc {
                    let invite = Invite(snapshot: document)
                    if invite.invite == true {
                        guard let nameFromUser = invite.fromUserName else { return }
                        self.accpetOrDeclineInvite(title: "\(NSLocalizedString("inviteAlertTitle", comment: ""))", message: "\(NSLocalizedString("inviteAlertMessage", comment: "")) \(nameFromUser)?")
                    }
                }
            }
        }
    }
    
    func acceptInvite(invite: Invite) {
        guard let userId = self.auth.currentUser?.uid else { return }
        guard let name = self.auth.currentUser?.displayName else { return }
        guard let email = self.auth.currentUser?.email else { return }
        
        // 1. lägg till dig själv som medlem i familyaccountet som du är invitad till
        db.collection("familyAccounts").document(invite.fromUserId).collection("members").document(userId).setData(["name" : name])
        
        // 2. lägg till familyaccountet som du accpterar som ditt eget familyaccount
        db.collection("users").document(userId).setData(["name" : name, "email" : email, "familyAccount" : invite.fromUserId])
        
        // 3. radera inviten
        db.collection("users").document(userId).collection("invites").document(invite.fromUserId).delete()
    }
    func accpetOrDeclineInvite(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("acceptInvite", comment: ""))", style: .default) { (UIAlertAction) in
            guard let userId = self.auth.currentUser?.uid else { return }
            
            self.db.collection("users").document(userId).collection("invites").addSnapshotListener() {
                (snapshot, error) in
                
                if let error = error {
                    print("No users \(error)")
                } else {
                    guard let snapDoc = snapshot?.documents else { return }
                    
                    for document in snapDoc {
                        let invite = Invite(snapshot: document)
                        self.invites.append(invite)
                    }
                    for invite in self.invites {
                        self.acceptInvite(invite: invite)
                    }
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("declineInvite", comment: ""))", style: .default) { (UIAlertAction) in
            self.db.collection("users").getDocuments() {
                (snapshot, error) in
                
                if let error = error {
                    print("No users \(error)")
                } else {
                    
                    guard let snapDoc = snapshot?.documents else { return }
                    
                    for document in snapDoc {
                        let user = User(snapshot: document)
                        self.users.append(user)
                    }
                }
                for user in self.users {
                    let invite = Invite(fromUserId: user.userId, fromUserName: user.name )
                    self.declineInvite(invite: invite)
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "\(NSLocalizedString("laterInvite", comment: ""))", style: .default) { (UIAlertAction) in
        })
        self.present(alert, animated: true, completion:  nil)
    }
    
    func declineInvite(invite: Invite) {
        guard let userId = self.auth.currentUser?.uid else { return }
        
        // radera inviten
        db.collection("users").document(userId).collection("invites").document(invite.fromUserId).delete() {
            error in
            if let error = error {
                print("david Error: \(error)")
            } else {
                print("david sucess")
            }
            
        }
    }
}
