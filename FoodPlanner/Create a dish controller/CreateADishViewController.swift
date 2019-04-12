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
    @IBOutlet weak var nameOnIngredientsLAbel: UITableView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var cookingDescriptionTextView: UITextView!
    @IBOutlet weak var stepperTextField: UITextField!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var tapToAddAPictureLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
    
    var db: Firestore!
    var auth: Auth!
    
    let imagePickerController: UIImagePickerController = UIImagePickerController()
    
    var ingredientsAmount: Int = 0
    var labelIsHidden: Bool = true
    var dishes : Dishes?
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
        imagePickerController.delegate = self
        ingredientTextField.delegate = self
        stepperTextField.delegate = self
        unitTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        cookingDescriptionTextView.delegate = self
        cookingDescriptionTextView.layer.zPosition = 1
        
        tapOnTapHereLabelToAddAPicture()
        self.hideKeyboard()
        showAndHideKeyboardWithNotifications()
    }
    
    func showAndHideKeyboardWithNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == ingredientTextField || textField == stepperTextField || textField == unitTextField {
            UITextView.animate(withDuration: 0.2, animations: { self.ingredientTextField.frame.origin.y = 320 })
            UITextView.animate(withDuration: 0.2, animations: { self.stepperTextField.frame.origin.y = 320 })
            UITextView.animate(withDuration: 0.2, animations: { self.unitTextField.frame.origin.y = 320 })
            UITableView.animate(withDuration: 0.2, animations: { self.tableView.frame.origin.y = 390 })
            UIStepper.animate(withDuration: 0.2, animations: { self.stepper.frame.origin.y = 320})
            UIButton.animate(withDuration: 0.2, animations: { self.addButton.frame.origin.y = 353})
            UIView.animate(withDuration: 0.7, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { self.stepsLabel.alpha = 0.0 }, completion: nil)
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == ingredientTextField || textField == stepperTextField || textField == unitTextField {
            UITextView.animate(withDuration: 0.2, animations: { self.ingredientTextField.frame.origin.y = 375 })
            UITextView.animate(withDuration: 0.2, animations: { self.stepperTextField.frame.origin.y = 375 })
            UITextView.animate(withDuration: 0.2, animations: { self.unitTextField.frame.origin.y = 375 })
            UITableView.animate(withDuration: 0.2, animations: { self.tableView.frame.origin.y = 450 })
            UIStepper.animate(withDuration: 0.2, animations: { self.stepper.frame.origin.y = 375})
            UIButton.animate(withDuration: 0.2, animations: { self.addButton.frame.origin.y = 413})
            UIView.animate(withDuration: 0.7, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: { self.stepsLabel.alpha = 1.0 }, completion: nil)
        }
    }
    
    @objc func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == cookingDescriptionTextView {
            UITextView.animate(withDuration: 0.2, animations: { self.cookingDescriptionTextView.frame.origin.y = 320 })
            hideLabelsAndButtons()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == cookingDescriptionTextView {
            UITextView.animate(withDuration: 0.2, animations: { self.cookingDescriptionTextView.frame.origin.y = 620 })
            showLabelsAndButtons()
        }
    }
    
    func hideLabelsAndButtons() {
        ingredientsTableView.isHidden = true
        stepperTextField.isHidden = true
        ingredientTextField.isHidden = true
        stepper.isHidden = true
        unitTextField.isHidden = true
        addButton.isHidden = true
        stepsLabel.isHidden = true
    }
    
    func showLabelsAndButtons() {
        ingredientsTableView.isHidden = false
        stepperTextField.isHidden = false
        ingredientTextField.isHidden = false
        stepper.isHidden = false
        unitTextField.isHidden = false
        addButton.isHidden = false
        stepsLabel.isHidden = false
    }
    
    func tapOnTapHereLabelToAddAPicture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        dishImageView.isUserInteractionEnabled = true
        dishImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openCameraOrPhotoLibrary()
        tapToAddAPictureLabel.isHidden = labelIsHidden
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        ingredientsAmount = Int(sender.value)
        stepperTextField.text = String(ingredientsAmount)
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
        dishImageView.layer.borderWidth = 1
        dishImageView.layer.borderColor = Theme.current.borderColorForImageViewAddDishController.cgColor
        dishImageView.layer.cornerRadius = 10
        
        stepper.layer.masksToBounds = true
        stepper.layer.cornerRadius = 5
        stepper.layer.borderWidth = 1
        stepper.layer.borderColor = Theme.current.borderAndTextColorForStepperAndAddButton.cgColor
        
        addButton.layer.borderColor = Theme.current.borderAndTextColorForStepperAndAddButton.cgColor
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 1
        addButton.titleLabel?.font = UIFont(name: Theme.current.fontForButtons, size: 18)
        addButton.setTitleColor(Theme.current.borderAndTextColorForStepperAndAddButton, for: .normal)
        
        navigationBar.barTintColor = Theme.current.backgroundColorAddDishController
        navigationBar.tintColor = Theme.current.navigationbarTextColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.current.navigationbarTextColor]
    }
    
    @IBAction func addIngredientsButton(_ sender: UIButton) {
        createIngredients()
    }
    
    func createIngredients() {
        // Convert the text string to an int
        ingredientsAmount = Int(stepperTextField.text!)!
        
        // Check so that the text strings are not empty. If they are empty then an alert
        // comes upp that tells the user to fill in all fields.
        if ingredientTextField.text == "" || unitTextField.text == "" || stepperTextField.text == "" {
            alertMessage(titel: "You must fill in all fields", message: "Please try again")
        } else {
            let saveIngredient = Ingredient(ingredientsTitle: ingredientTextField.text!, amount: ingredientsAmount, unit: unitTextField.text!)
            ingredients.append(saveIngredient)
            
            let indexPath = IndexPath(row: ingredients.count-1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            // When the user presses the Add button, then all fields will be restored.
            ingredientTextField.text! = ""
            unitTextField.text! = ""
            stepperTextField.text! = ""
            ingredientsAmount = 0
            stepper.value = 0
            
            // Dismiss the keyboard
            view.endEditing(true)
        }
    }
    
    @IBAction func saveDishItemButton(_ sender: UIBarButtonItem) {
        saveDish()
    }
    
    func saveDish() {
        let uid = auth.currentUser
        guard let userId = uid?.uid else { return }
        userID = userId
        var dishPicture = UIImage()
        var cookingDescription = UITextView()
        
        if let dishImage = dishImageView.image {
            dishPicture = dishImage
        }
        
        if let currentCookingDescription = cookingDescriptionTextView {
            cookingDescription = currentCookingDescription
        }
        
        if nameOnDishTextField.text == "" {
            alertMessage(titel: "Your dish must have a name!", message: "Please try again")
        } else {
            
            let saveDish = Dish(dishTitle: nameOnDishTextField.text!, dishImageId: dishPicture, ingredientsAndAmount: ingredients, cooking: cookingDescription.text)
            
            if dishes!.add(dish: saveDish) == true {
                
            } else {
                print("Error getting saved")
            }
            
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
            print("Upload task finished")
            print(metadata ?? "No metadat")
            print(error ?? "No error")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "No more progress")
        }
        
        uploadTask.resume()
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // Get a picture from the user's photo album or open the camera.
    func openCameraOrPhotoLibrary() {
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                self.alertMessage(titel: "Your device have no camera", message: "Please use your photo library")
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCellIngredients") as! IngredientTableViewCell
        
        cell.setIngredientsTitle(title: ingredient, amount: ingredient, unit: ingredient)
        
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        return cell
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
