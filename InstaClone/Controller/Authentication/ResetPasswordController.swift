//
//  ResetPasswordController.swift
//  InstaClone
//
//  Created by Giorgi on 1/10/21.
//

import UIKit

protocol ResetPasswordControllerDelegate: class {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

 class ResetPasswordController: UIViewController {
    
    //MARK: - Properties
    private var viewModel = ResetpasswordViewModel()
    weak var delegate: ResetPasswordControllerDelegate?
    
    private let emailTextField = AuthenticationTextField(placeholder: "Email", type: .emailAddress)
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "instagram-logo"))
    private let resetPasswordButton = AuthenticationButton(title: "Reset Password")
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    var email: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dismissKeyboard()
    }
    
    
    //MARK: - Helper Methods
    
    func configureUI() {
        view.backgroundColor = .white

        emailTextField.text = email
        viewModel.email = email
        updateForm()
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(iconImage)
        iconImage.contentMode = .scaleAspectFill
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 120, width: 240)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         paddingTop: 72)
        
        configureStack()
        
        backButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        
       
    }
    
    func configureStack() {
        let stack = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left:  view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        resetPasswordButton.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        
    }
    
    
    //MARK: - Selectors
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else {return}
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { error in
            self.showLoader(false)
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "Ok")
            return
            }
            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange (sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        updateForm()
    }
}


extension ResetPasswordController: FormViewModel{
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }   
}
