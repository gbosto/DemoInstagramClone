//
//  LoginController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

protocol AuthenticationDelegate: class {
    func AuthenticationDidComplete()
}

 class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let emailTextField = AuthenticationTextField(placeholder: "Email", type: .emailAddress)
    private let passwordTextField = AuthenticationTextField(placeholder: "Password", secureTextEntry: true)
    private let dontHaveAccountButton =  AttributedButton(text: "Don't Have Account?", boldText: "Sign Up")
    private let loginButton = AuthenticationButton(title: "Sign In")
    private let iconImage: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "instagram-logo"))
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Forgot password?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return button
    }()
    
    private let toggleSecureTextButton = TogglePasswordButton(type: .system)

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dismissKeyboard()
    }
    
    //MARK: - Helper Methods
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 120, width: 240)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         paddingTop: 72)

        let stack = configureStack()
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stack.bottomAnchor, right: view.rightAnchor,
                                    paddingTop: 5, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     paddingBottom: 16)
        dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)

    }
    
    func configureStack() -> UIStackView{
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stack.axis = .vertical
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left:  view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordTextField.clearButtonMode = .never
        passwordTextField.addSubview(toggleSecureTextButton)
        toggleSecureTextButton.centerY(inView: passwordTextField)
        toggleSecureTextButton.anchor(right: passwordTextField.rightAnchor, paddingRight: 8)
        toggleSecureTextButton.delegate = self
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(handleShowResetpassword), for: .touchUpInside)
        
        return stack
    }
    
    
    //MARK: - Selectors
    
    @objc func handleToggleSecureText() {
        
    }
    
    @objc func handleShowResetpassword() {
        let controller = ResetPasswordController()
        controller.delegate = self
        controller.email = emailTextField.text
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = self.delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange (sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        updateForm()
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        showLoader(true)
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            self.showLoader(false)
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "Ok")
            }
            if let _ = result {
                self.delegate?.AuthenticationDidComplete()
            }
        }
    }
}

    //MARK: - FormViewModel

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}

    //MARK: - UITextFieldDelegate

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - ResetPasswordControllerDelegate

extension LoginController: ResetPasswordControllerDelegate {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController) {
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Success", message: "We sent a link to your email to reset your password", dissmissalText: "Ok")
    }
}

//MARK: - TogglePasswordButtonDelegate

extension LoginController: TogglePasswordButtonDelegate {
    func buttonPressed(button: TogglePasswordButton) {
        button.isSecured.toggle()
        guard let eyeSlashImage = UIImage(systemName: "eye.slash"),
              let eyeImage = UIImage(systemName: "eye") else {return}
        
        var buttonImage: UIImage {return button.isSecured ? eyeSlashImage : eyeImage}
        var buttonTintColor: UIColor {return button.isSecured ? .lightGray : .black}
        
        toggleSecureTextButton.setImage(buttonImage, for: .normal)
        toggleSecureTextButton.tintColor = buttonTintColor
        passwordTextField.isSecureTextEntry.toggle()
    }
}
