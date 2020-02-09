//
//  enterName.swift
//  MainProject
//
//  Created by Markus Becerra on 2/8/20.
//  Copyright © 2020 Big-Segfault-Energy. All rights reserved.
//

import UIKit

class enterName: UIViewController {
    @IBOutlet weak var nameInput: UITextField!
    private func configureTextFields()
       {
           nameInput.delegate = self
       }

    override func viewDidLoad() {
                super.viewDidLoad()
                configureTextFields()
                configureTapGesture()
            }

private func configureTapGesture(){
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(enterName.handleTap))
    view.addGestureRecognizer(tapGesture)
    
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        
        view.endEditing(true)
        userName = nameInput.text ?? "this didnt work"
        
    }
    
    @objc func handleTap()
    {
        view.endEditing(true)
    }
   
}

extension enterName: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
