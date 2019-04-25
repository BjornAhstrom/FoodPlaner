//
//  DishIngredientsViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class CreateADishViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameOnDishTextField: UITextField!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var portionsLabel: UILabel!
    @IBOutlet weak var portionsAmountStepper: UIStepper!
    @IBOutlet weak var portonsAmountTextField: UITextField!
    @IBOutlet weak var nameOnIngredientsLAbel: UITableView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var cookingDescriptionTextView: UITextView!
//    @IBOutlet weak var stepperTextField: UITextField!
//    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var unitTextField: UITextField!
//    @IBOutlet weak var IngredientsAmountStepper: UIStepper!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
    
    var db: Firestore!
    var auth: Auth!
    
    let imagePickerController: UIImagePickerController = UIImagePickerController()
    
    var ingredientsAmount: Double = 0
    var portionsAmount: Int = 0
    var labelIsHidden: Bool = true
    var ingredients: [Ingredient] = []
    var dishImageId: String = ""
    var userID: String = ""
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("usersImages").child(userID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFontColorRadiusOnTexFieldLabelAndView()
        db = Firestore.firestore()
        auth = Auth.auth()
        
        guard let image: UIImage = UIImage(named: "IOSCamera1") else { return }
        dishImageView.image = image
        
        imagePickerController.delegate = self
//        ingredientTextField.delegate = self
//        stepperTextField.delegate = self
//        unitTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        cookingDescriptionTextView.delegate = self
        cookingDescriptionTextView.layer.zPosition = 1
        
        tapOnImageViewToAddAPicture()
        self.hideKeyboard()
        showAndHideKeyboardWithNotifications()
    }
    
    func setFontColorRadiusOnTexFieldLabelAndView() {
        view.backgroundColor = Theme.current.backgroundColorAddDishController
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = Theme.current.borderColorForIngredentsTableViewAddDishController.cgColor
        tableView.layer.cornerRadius = 10
        cookingDescriptionTextView.layer.borderColor = Theme.current.borderColorForCookingDescriptionAddDishController.cgColor
        cookingDescriptionTextView.layer.borderWidth = 1
        cookingDescriptionTextView.layer.cornerRadius = 10
        dishImageView.layer.masksToBounds = true
//        dishImageView.layer.borderWidth = 1
//        dishImageView.layer.borderColor = Theme.current.borderColorForImageViewAddDishController.cgColor
        dishImageView.layer.cornerRadius = 10
        
//        IngredientsAmountStepper.layer.masksToBounds = true
//        IngredientsAmountStepper.layer.cornerRadius = 5
//        IngredientsAmountStepper.layer.borderWidth = 1
//        IngredientsAmountStepper.layer.borderColor = Theme.current.borderAndTextColorForStepperAndAddButton.cgColor
        
        addButton.layer.borderColor = Theme.current.borderAndTextColorForStepperAndAddButton.cgColor
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 1
        addButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 18)
        addButton.setTitleColor(Theme.current.borderAndTextColorForStepperAndAddButton, for: .normal)
        
        navigationBar.barTintColor = Theme.current.backgroundColorAddDishController
        navigationBar.tintColor = Theme.current.navigationbarTextColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.current.navigationbarTextColor]
    }
    
    func showAndHideKeyboardWithNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == ingredientTextField || textField == stepperTextField || textField == unitTextField {
//            UITextView.animate(withDuration: 0.2, animations: { self.ingredientTextField.frame.origin.y = 320 })
//            UITextView.animate(withDuration: 0.2, animations: { self.stepperTextField.frame.origin.y = 320 })
//            UITextView.animate(withDuration: 0.2, animations: { self.unitTextField.frame.origin.y = 320 })
            UITableView.animate(withDuration: 0.2, animations: { self.tableView.frame.origin.y = 390 })
//            UIStepper.animate(withDuration: 0.2, animations: { self.IngredientsAmountStepper.frame.origin.y = 320})
            UIButton.animate(withDuration: 0.2, animations: { self.addButton.frame.origin.y = 353})
            UIView.animate(withDuration: 0.7, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { self.stepsLabel.alpha = 0.0 }, completion: nil)
             hidePortionsStepperLabelAndTextField()
//        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == ingredientTextField || textField == stepperTextField || textField == unitTextField {
//            UITextView.animate(withDuration: 0.2, animations: { self.ingredientTextField.frame.origin.y = 375 })
//            UITextView.animate(withDuration: 0.2, animations: { self.stepperTextField.frame.origin.y = 375 })
//            UITextView.animate(withDuration: 0.2, animations: { self.unitTextField.frame.origin.y = 375 })
            UITableView.animate(withDuration: 0.2, animations: { self.tableView.frame.origin.y = 450 })
//            UIStepper.animate(withDuration: 0.2, animations: { self.IngredientsAmountStepper.frame.origin.y = 375})
            UIButton.animate(withDuration: 0.2, animations: { self.addButton.frame.origin.y = 413})
            UIView.animate(withDuration: 0.7, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: { self.stepsLabel.alpha = 1.0 }, completion: nil)
            showPortionsStepperLabelAndTextField()
//        }
    }
    
    @objc func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == cookingDescriptionTextView {
            UITextView.animate(withDuration: 0.2, animations: { self.cookingDescriptionTextView.frame.origin.y = 320 })
            hideLabelsAndButtons()
            hidePortionsStepperLabelAndTextField()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == cookingDescriptionTextView {
            UITextView.animate(withDuration: 0.2, animations: { self.cookingDescriptionTextView.frame.origin.y = 620 })
            showLabelsAndButtons()
            showPortionsStepperLabelAndTextField()
        }
    }
    
    func hidePortionsStepperLabelAndTextField() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.portionsLabel.alpha  = 0.0 }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.portonsAmountTextField.alpha = 0.0 }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.portionsAmountStepper.alpha  = 0.0 }, completion: nil)
        portionsLabel.isHidden = true
        portonsAmountTextField.isHidden = true
        portionsAmountStepper.isHidden = true
    }
    
    func showPortionsStepperLabelAndTextField() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.portionsLabel.alpha  = 1.0 }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.portonsAmountTextField.alpha = 1.0 }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.portionsAmountStepper.alpha  = 1.0 }, completion: nil)
        portionsLabel.isHidden = false
        portonsAmountTextField.isHidden = false
        portionsAmountStepper.isHidden = false
    }
    
    func hideLabelsAndButtons() {
//        UIView.animate(withDuration: 0.2, delay: 0.0, options:
//            UIView.AnimationOptions.curveEaseIn, animations: { self.ingredientTextField.alpha  = 0.0 }, completion: nil)
//        UIView.animate(withDuration: 0.2, delay: 0.0, options:
//            UIView.AnimationOptions.curveEaseIn, animations: { self.stepperTextField.alpha  = 0.0 }, completion: nil)
//        UIView.animate(withDuration: 0.2, delay: 0.0, options:
//            UIView.AnimationOptions.curveEaseIn, animations: { self.unitTextField.alpha  = 0.0 }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.tableView.alpha  = 0.0 }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.addButton.alpha  = 0.0 }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.stepsLabel.alpha  = 0.0 }, completion: nil)
    }
    
    func showLabelsAndButtons() {
//        UIView.animate(withDuration: 0.5, delay: 0.0, options:
//            UIView.AnimationOptions.curveEaseIn, animations: { self.ingredientTextField.alpha  = 1.0 }, completion: nil)
//        UIView.animate(withDuration: 0.5, delay: 0.0, options:
//            UIView.AnimationOptions.curveEaseIn, animations: { self.stepperTextField.alpha  = 1.0 }, completion: nil)
//        UIView.animate(withDuration: 0.5, delay: 0.0, options:
//            UIView.AnimationOptions.curveEaseIn, animations: { self.unitTextField.alpha  = 1.0 }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.tableView.alpha  = 1.0 }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.addButton.alpha  = 1.0 }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseIn, animations: { self.stepsLabel.alpha  = 1.0 }, completion: nil)
    }
    
    func tapOnImageViewToAddAPicture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        dishImageView.isUserInteractionEnabled = true
        dishImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openCameraOrPhotoLibrary()
    }
    
    func alertForAddAIngredient() {
        //Create the alert controller.
        let alert = UIAlertController(title: "\(NSLocalizedString("addIngredientAlertTitle", comment: ""))", message: "\(NSLocalizedString("addIngredientAlertMessage", comment: ""))", preferredStyle: .alert)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = Theme.current.backgroundColorAddDishController
        
        //Add the text field. You can configure it however you need.
        alert.addTextField { (ingredientField) in
            ingredientField.placeholder = "\(NSLocalizedString("placeholderIngName", comment: ""))"
        }
        
        alert.addTextField { (amountField) in
            amountField.placeholder = "\(NSLocalizedString("placeholderIngAmount", comment: ""))"
        }
        
        alert.addTextField { (unitField) in
            unitField.placeholder = "\(NSLocalizedString("placeholderIngUnit", comment: ""))"
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "\(NSLocalizedString("cancel", comment: ""))", style: .destructive, handler: { (_) in self.showPortionsStepperLabelAndTextField() })
        
        //the confirm action taking the inputs
        let acceptAction = UIAlertAction(title: "\(NSLocalizedString("add", comment: ""))", style: .default, handler: { [weak alert] (error) in
            guard let ingredientField = alert?.textFields?[0], let amountField = alert?.textFields?[1], let unitField = alert?.textFields?[2] else {
                print("Issue with Alert TextFields \(error)")
                return
            }
            guard let ingredientText = ingredientField.text, let amountText = amountField.text, let unitText = unitField.text else {
                print("Issue with TextFields Text \(error)")
                return
            }
            self.createIngredients(ingredientText: ingredientText, amountText: amountText, unitText: unitText)
        })
        
        //adding the actions to alertController
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }
    
//    @IBAction func ingredientsAmountStepper(_ sender: UIStepper) {
//            ingredientsAmount = Double(sender.value)
//        stepperTextField.text =  String(ingredientsAmount)
//    }
   
    @IBAction func portionsAmountStepper(_ sender: UIStepper) {
        portionsAmount = Int(sender.value)
        portonsAmountTextField.text = String(portionsAmount)
    }
 
    
    @IBAction func addIngredientsButton(_ sender: UIButton) {
        alertForAddAIngredient()
        //createIngredients()
    }
    
    func getDoubleFromLocalNumber(input: String) -> Double {
        var value = 0.0
        let numberFormatter = NumberFormatter()
        let decimalFiltered = input.replacingOccurrences(of: "٫|,", with: ".", options: .regularExpression)
        numberFormatter.locale = Locale(identifier: "\(NSLocalizedString("numberLanguageFormatter", comment: ""))")
        if let amountValue = numberFormatter.number(from: decimalFiltered) {
            value = amountValue.doubleValue
        }
        return value
    }
    
    func createIngredients(ingredientText: String, amountText: String, unitText: String) {
        // Convert the text string to an Double
//        guard let amountText = stepperTextField.text else { return }
//        guard let ingredientText = ingredientTextField.text else { return }
//        guard let unitText = unitTextField.text else { return }
        
        let ingAmount = getDoubleFromLocalNumber(input: amountText)
        ingredientsAmount = ingAmount
        
        // Check so that the text strings are not empty. If they are empty then an alert
        // comes upp that tells the user to fill in all fields.
        if ingredientText == "" || unitText == "" || unitText == "" {
            alertMessage(titel: "\(NSLocalizedString("allFields", comment: ""))", message: "\(NSLocalizedString("alertMessage_TryAgain", comment: ""))")
        } else {
            let saveIngredient = Ingredient(ingredientsTitle: ingredientText, amount: ingredientsAmount, unit: unitText)
            ingredients.append(saveIngredient)
            
            let indexPath = IndexPath(row: ingredients.count-1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            // When the user presses the Add button, then all fields will be restored.
//            ingredientTextField.text = ""
//            unitTextField.text = ""
//            stepperTextField.text = ""
            ingredientsAmount = 0
//            IngredientsAmountStepper.value = 0
            
            // Dismiss the keyboard
            view.endEditing(true)
            showPortionsStepperLabelAndTextField()
        }
    }
    
    @IBAction func saveDishItemButton(_ sender: UIBarButtonItem) {
        saveDish()
    }
    
    func saveDish() {
        let uid = auth.currentUser
        guard let userId = uid?.uid else { return }
        userID = userId
        
        guard let nameOnDishTextField = nameOnDishTextField.text else { return }
        var dishPicture = UIImage()
        var cookingDescription = UITextView()
        
        if let dishImage = dishImageView.image {
            dishPicture = dishImage
        }
        
        if let currentCookingDescription = cookingDescriptionTextView {
            cookingDescription = currentCookingDescription
        }
        
        if nameOnDishTextField == "" {
            alertMessage(titel: "\(NSLocalizedString("mustHaveDishName", comment: ""))", message: "\(NSLocalizedString("alertMessage_TryAgain", comment: ""))")
        } else {
            
            let saveDish = Dish(dishTitle: nameOnDishTextField, dishImageId: dishPicture, ingredientsAndAmount: ingredients, cooking: cookingDescription.text, portions: portionsAmount)
            
           // guard dishes?.add(dish: saveDish) == true else { return }
                
//            } else {
//                print("Error getting saved")
//            }
            
            let docRef = db.collection("users").document(userId).collection("dishes").addDocument(data: saveDish.toAny())
            dishImageId = docRef.documentID
            
            for ingredient in ingredients {
                docRef.collection("ingredients").addDocument(data: ingredient.toAny())
            }
            upploadImageToStorage()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func upploadImageToStorage() {
        guard let image = dishImageView.image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        
        let uploadImageRef = imageReference.child(dishImageId)
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            //print("Upload task finished")
            print(metadata ?? "No metadat")
            print(error ?? "No error")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            //print(snapshot.progress ?? "No more progress")
        }
        
        uploadTask.resume()
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // Get a picture from the user's photo album or open the camera.
    func openCameraOrPhotoLibrary() {
        let actionSheet = UIAlertController(title: "\(NSLocalizedString("photoSourceTitle", comment: ""))", message: "\(NSLocalizedString("chooseMessage", comment: ""))", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "\(NSLocalizedString("cameraTitle", comment: ""))", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                self.alertMessage(titel: "\(NSLocalizedString("noCameraTitle", comment: ""))", message: "\(NSLocalizedString("noCameraMessage", comment: ""))")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "\(NSLocalizedString("photoLibraryTitle", comment: ""))", style: .default, handler: { (action:UIAlertAction) in self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "\(NSLocalizedString("cancelTitle", comment: ""))", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dishImageView.image = image
            
            
            
        } else {
            print("Error")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateADishViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = ingredients[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCellIngredients") as? IngredientTableViewCell
        
        cell?.setIngredientsTitle(title: ingredient, amount: ingredient, unit: ingredient)
        
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.white
        cell?.selectedBackgroundView = backgroundView
        
        return cell ?? cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
