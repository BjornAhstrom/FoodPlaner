//
//  SavedDishViewController.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-03-08.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import UIKit
import Firebase

class ShowDishViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var dishName: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cookingDescriptionTextView: UITextView!
    
    private var savedDishCell: String = "savedDishCell"
    private var DishesViewController: String = "DishesViewController"
    
    let db = Firestore.firestore()
    var dish: Dish?
    var dishId: String?
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("dishImages")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        dishName.text = dish?.dishName
        //imageView.image = dish?.dishImage
        
        cookingDescriptionTextView.text = dish?.cooking
        
        downloadImageFromStorage()
    }
    
    func downloadImageFromStorage() {
        let downloadImageRef = imageReference.child(dishId ?? "No dishId")
        
        print("downloadImageRef.name: \(downloadImageRef.name), dishId: \(dishId!)")
        if downloadImageRef.name == dishId {
            let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
                if let error = error {
                    print("!!!!!! Error downloading")
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        self.imageView.image = image
                    }
                    print(error ?? "No error")
                }
            }
            //            downloadTask.observe(.progress) { (snapshot) in
            //                //print(snapshot.progress ?? "No more progress")
            //            }
            //            downloadTask.resume()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dish = dish {
            return (dish.ingredientsAndAmount.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: savedDishCell, for: indexPath) as? ShowDishTableViewCell
        
        if let ingredients = dish?.ingredientsAndAmount
        {
            let title = ingredients[indexPath.row].ingredientsTitle
            let amount = ingredients[indexPath.row].amount
            let unit = ingredients[indexPath.row].unit
            
            cell?.ingredientsNameLabel.text = title
            cell?.ingredientsAmountLabel.text = "\(amount) \(unit)"
        }
        return cell!
    }
    
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteRecipeItemButton(_ sender: UIBarButtonItem) {
        deleteRecipe()
        dismiss(animated: true, completion: nil)
    }
    
    func deleteRecipe() {
        db.collection("dishes").document((dish?.dishID)!).delete() { err in
            if let err = err {
                print("Error deleting document: \(err)")
            } else {
                print("Document successfully deleted!")
            }
        }
    }
}

