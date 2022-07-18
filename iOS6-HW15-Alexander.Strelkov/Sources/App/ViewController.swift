//
//  ViewController.swift
//  iOS6-HW15-Alexander.Strelkov
//
//  Created by Alexandr Strelkov on 11.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var isStopped: Bool = false
    
    //MARK: IBOutlets and IBActions:
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func searchPasswordButton(_ sender: UIButton) {
        if textField.text != "" {
            self.stopButton.isEnabled = true
            self.bruteForce(passwordToUnlock: textField.text ?? "")
        } else {
            label.text = "nothing to search"
        }
    }
    
    @IBAction func generateButton(_ sender: UIButton) {
        textField.text = "\(String.randomPasswordGenerate())"
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        textField.text = ""
        label.text = ""
        textField.isSecureTextEntry = true
        isStopped = false
        clearButton.isEnabled = false
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        isStopped = true
    }
    
    //MARK: ViewDidLoad:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        textField.isSecureTextEntry = true
        clearButton.isEnabled = false
        stopButton.isEnabled = false
    }
    
    //MARK: BruteForce Method
    
    func bruteForce(passwordToUnlock: String) {
        let mainQueue = DispatchQueue.main
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        let backgroundQueue = DispatchQueue.global(qos: .background)
        backgroundQueue.async {
            let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
            var password: String = ""
            while password != passwordToUnlock && !self.isStopped {
                password = String.generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                mainQueue.async {
                    self.label.text = "Hacking.. \(password)"
                    if password == passwordToUnlock {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.textField.isSecureTextEntry = false
                        self.label.text = "Hacked! Password: \(password)"
                        self.clearButton.isEnabled = true
                        self.stopButton.isEnabled = false
                    }
                }
                if self.isStopped {
                    mainQueue.async {
                        self.activityIndicator.isHidden = true
                        self.label.text = "Password \(password) is not hacked!"
                        self.clearButton.isEnabled = true
                    }
                    break
                }
            }
        }
    }
}
