//
//  DishIngredientsViewController.swift
//  FoodPlaner
//
//  Created by Björn Åhström on 2019-03-06.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit

class CreateADishViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
    
    var ingredientsAmount: Int = 0
    var labelIsHidden: Bool = true
    
    var dishes : Dishes?
    var ingredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setFontColorRadiusOnTexFieldLabelAndView()
        tapOnTapHereLabelToAddAPicture()
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
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = Theme.current.colorForBorder.cgColor
        tableView.layer.cornerRadius = 10
        cookingDescriptionTextView.layer.borderColor = Theme.current.colorForBorder.cgColor
        cookingDescriptionTextView.layer.borderWidth = 1
        cookingDescriptionTextView.layer.cornerRadius = 10
        dishImageView.layer.masksToBounds = true
        dishImageView.layer.borderWidth = 1
        dishImageView.layer.borderColor = Theme.current.colorForBorder.cgColor
        dishImageView.layer.cornerRadius = 10
        stepper.layer.borderColor = Theme.current.colorForBorder.cgColor
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
            alertMessage(titel: "You must fill in all fields")
        } else {
            ingredients.append(Ingredient(ingredientsTitle: ingredientTextField.text!, amount: ingredientsAmount, unit: unitTextField.text!))
            
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
        //var dishName: String = ""
        var dishPicture = UIImage()
        var cookingDescription = UITextView()
        
        if let dishImage = dishImageView.image {
            dishPicture = dishImage
        }
        
        if let currentCookingDescription = cookingDescriptionTextView {
            cookingDescription = currentCookingDescription
        }
        
        if nameOnDishTextField.text == "" {
            alertMessage(titel: "Your dish must have a name!")
        } else {
            let saveDish = Dish(dishTitle: nameOnDishTextField.text!, dishImage: dishPicture, ingredientsAndAmount: ingredients, cooking: cookingDescription)
            dishes!.add(dishes: saveDish)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // Get a picture from the user's photo album or open the camera.
    func openCameraOrPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.alertMessage(titel: "Your device have no camera")
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
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
    
    func alertMessage(titel: String) {
        let alert = UIAlertController(title: titel, message: "Pleace try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
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
