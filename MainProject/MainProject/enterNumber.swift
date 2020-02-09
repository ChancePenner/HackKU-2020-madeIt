//
//  enterNumber.swift
//  MainProject
//
//  Created by Chance Penner on 2/9/20.
//  Copyright © 2020 Big-Segfault-Energy. All rights reserved.
//

import UIKit

class enterNumber: UIViewController {
    
    
    @IBOutlet weak var inputNumber: UITextField!
    private func configureTextFields()
           {
               inputNumber.delegate = self
           }

        override func viewDidLoad() {
                    super.viewDidLoad()
                    configureTextFields()
                    configureTapGesture()
                }

    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(enterNumber.handleTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    @IBAction func buttonSubmit(_ sender: Any) {        view.endEditing(true)
        phoneNumber = inputNumber.text ?? "this didnt work"
        
    }
   
        
       @objc func handleTap()
       {
           view.endEditing(true)
       }
    }

    extension enterNumber: UITextFieldDelegate
    {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
