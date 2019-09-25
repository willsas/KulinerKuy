//
//  CreateOfferViewController.swift
//  KulinerKuy
//
//  Created by Willa on 19/09/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import UIKit

class CreateOfferViewController: UIViewController {
    
    @IBOutlet var tittleTextFieldOutlet: UITextField!
    
    @IBOutlet var priceTextFieldOutlet: UITextField!
    
    @IBOutlet var peopleTextFieldOutlet: UITextField!
    
    @IBOutlet var nameTextField: UITextField!
    
    
    let db = OfferDataBaseModel.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if tittleTextFieldOutlet.text?.count != 0  && priceTextFieldOutlet.text?.count != 0 && peopleTextFieldOutlet.text?.count != 0 {
            db.saveData(offerTitle: tittleTextFieldOutlet.text!, price: priceTextFieldOutlet.text!, people: Int(peopleTextFieldOutlet.text!) ?? 0, isPrivate: true, name: nameTextField.text!)
            db.saveData(offerTitle: tittleTextFieldOutlet.text!, price: priceTextFieldOutlet.text!, people: Int(peopleTextFieldOutlet.text!) ?? 0, isPrivate: false, name: nameTextField.text!)
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
