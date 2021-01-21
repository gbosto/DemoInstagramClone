//
//  Registration.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

 class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private let emailTextField = AuthenticationTextField(placeholder: "Email", type: .emailAddress)
    private let passwordTextField = AuthenticationTextField(placeholder: "Password",  secureTextEntry: true)
    private let fullNameTextField = AuthenticationTextField(placeholder: "Full Name")
    private let usernameTextField = AuthenticationTextField(placeholder: "Username")
    private let signUpButton = AuthenticationButton(title: "Sign Up")
    private let alreadyHaveAnAccountButton = AttributedButton(text: "Already have an Account?",
                                                                    boldText: "Log In")
    private let toggleSecureTextButton = TogglePasswordButton(type: .system)
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.crop.circle.fill")
        view.tintColor = .lightGray
        view.setDimensions(height: 120, width: 120)
        view.layer.cornerRadius = 120 / 2
        
        return view
    }()
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Profile Photo", for: .normal)
        button.setDimensions(height: 40, width: 120)
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)

        return button
    }()
   
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    //MARK: - Helper Methods

    func configureUI() {
        view.backgroundColor = .white

        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(addPhotoButton)
        addPhotoButton.centerX(inView: view)
        addPhotoButton.anchor(top: profileImageView.bottomAnchor)
        
        configureStack()
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        alreadyHaveAnAccountButton.centerX(inView: view)
        alreadyHaveAnAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 16)
    }
    
    func configureStack() {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,
                                                   fullNameTextField, usernameTextField, signUpButton])
        stack.axis = .vertical
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 12, paddingLeft: 32, paddingRight: 32)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        
        passwordTextField.clearButtonMode = .never
        passwordTextField.addSubview(toggleSecureTextButton)
        toggleSecureTextButton.centerY(inView: passwordTextField)
        toggleSecureTextButton.anchor(right: passwordTextField.rightAnchor, paddingRight: 8)
        toggleSecureTextButton.delegate = self
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }
    
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    //MARK: - Selectors
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange (sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        updateForm()
    }
    
    @objc func handleProfilePhotoSelect() {
        let picker = configureImagePicker()
        picker.delegate = self
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullname = fullNameTextField.text,
              let username = usernameTextField.text?.lowercased(),
              let profileImage = profileImage else {return}
        
        let credentials = AuthCredentials(email: email, password: password,
                                          fullname: fullname, username: username,
                                          profileImage: profileImage)
        showLoader(true)
        AuthService.registerUser(withCredentials: credentials) { error in
            self.showLoader(false)
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "Ok")
                return
            }
            self.delegate?.AuthenticationDidComplete()
        }
    }
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

    //MARK: - FormViewModel

extension RegistrationController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}

    //MARK: - UIImagePickerControllerDelegate && UINavigationControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        profileImage = image
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.image = image.withRenderingMode((.alwaysOriginal))
                
        picker.dismiss(animated: true, completion: nil)
        
    }
}

    //MARK: - UITextFieldDelegate

extension RegistrationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            fullNameTextField.becomeFirstResponder()
        } else if textField == fullNameTextField {
            textField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - TogglePasswordButtonDelegate

extension RegistrationController: TogglePasswordButtonDelegate {
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
