//
//  SignUpVC.swift
//  RegistrationApp
//
//  Created by Максим Капанжи on 3.08.22.
//

import UIKit

final class SignUpVC: UIViewController {
    // MARK: - @IBOutlets
    
    @IBOutlet private var emailTF: UITextField!
    @IBOutlet private var errorEmailLbl: UILabel!
    /// Name
    @IBOutlet private var nameTF: UITextField!
    /// Password
    @IBOutlet private var errorPassLbl: UILabel!
    @IBOutlet private var passwordTF: UITextField!
    /// Views for pass indicators
    @IBOutlet private var strongPassIndicatorsViews: [UIView]!
    /// ConfPass
    @IBOutlet private var confPassTF: UIStackView!
    @IBOutlet private var errorConfPassLbl: UILabel!
    /// Continue
    @IBOutlet private var continueButton: UIButton!
    
    // MARK: - Properties
    
    private var isValidEmail = false { didSet {updateContinueBtnState()}}
    private var isConfPass = false { didSet {updateContinueBtnState()}}
    private var passwordStrength: PasswordStrength  = .veryWeak { didSet {updateContinueBtnState()}}
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions

    @IBAction func SignInBtnAction() {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func emailTFAction(_ sender: UITextField) {
        if let email = sender.text,
           !email.isEmpty,
           VerificationService.isValidEmail(email: email) {
            isValidEmail = true
        } else {
            isValidEmail = false
        }
        errorEmailLbl.isHidden = isValidEmail
    }
    @IBAction func passTFAction(_ sender: UITextField) {
        if let pass = sender.text,
           !pass.isEmpty {
            passwordStrength = VerificationService.isValidPassword(pass: pass)
        }
        errorPassLbl.isHidden = passwordStrength != .veryWeak
        setupStrongPassIndicatorsViews()
           
    }
    @IBAction func confirmPasswordTFAction(_ sender: UITextField) {
        if let confirmPasswordText = sender.text,
           !confirmPasswordText.isEmpty,
           let passwordText = passwordTF.text,
           !confirmPasswordText.isEmpty {
            isConfPass = VerificationService.isPassCofirm(pass1: passwordText, pass2: confirmPasswordText)
        } else { isConfPass = false }
        errorConfPassLbl.isHidden = isConfPass
        
    }
    @IBAction func continueButtonAction() {
         if let email = emailTF.text,
            let passwordText = passwordTF.text {
             let userModel = UserModel(name: nameTF.text, email: email, pass: passwordText)
             
             performSegue(withIdentifier: "goToCodeVerificationVC", sender: userModel)
         }
    }
    
    // MARK: - Functions
    
    private func setupStrongPassIndicatorsViews() {
        strongPassIndicatorsViews.enumerated().forEach { index, view in
            if index <= (passwordStrength.rawValue - 1) {
                view.alpha = 1
            } else {
                view.alpha = 0.1
            }
        }
    }
    
    private func updateContinueBtnState() {
        continueButton.isEnabled = isValidEmail && isConfPass && passwordStrength != .veryWeak
    }

     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let codeVerifVC = segue.destination as? CodeVerificationVC,
            let userModel = sender as? UserModel {
             codeVerifVC.userModel = userModel
         }
     }
    

}
