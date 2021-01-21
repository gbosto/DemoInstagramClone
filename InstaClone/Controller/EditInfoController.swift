//
//  EditInfoController.swift
//  InstaClone
//
//  Created by Giorgi on 1/13/21.
//

import UIKit

class EditInfoController: UIViewController {
    //MARK: - Properties
    
    private let forUsersName: Bool
    private let user: User
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .lightGray
        
        return view
    }()
    
    private let editInfoTextField: UITextField = {
        let view = UITextField()
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        view.leftView = spacer
        view.leftViewMode = .always
                
        view.clearButtonMode = .whileEditing
        view.borderStyle = .roundedRect
        view.textColor = .black
        view.keyboardAppearance = .dark
        view.setHeight(40)
        
        return view
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dismissKeyboard()
    }
    
    init(title: String, user: User, forUsersName: Bool ) {
        self.user = user
        self.forUsersName = forUsersName
        super.init(nibName: nil, bundle: nil)
        editInfoTextField.attributedPlaceholder = NSAttributedString(string: title,
                                                                     attributes: [.foregroundColor : UIColor.lightGray])
        titleLabel.text = title
        navigationItem.title = title
        if forUsersName {
            editInfoTextField.text = user.fullname
        } else {
            editInfoTextField.text = user.username
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Methods
    
    func configureUI() {
        view.backgroundColor = .white
        editInfoTextField.becomeFirstResponder()
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          paddingTop: 30, paddingLeft: 18)
        
        view.addSubview(editInfoTextField)
        editInfoTextField.centerX(inView: view)
        editInfoTextField.anchor(top: titleLabel.bottomAnchor,
                                 left: view.leftAnchor, right: view.rightAnchor,
                                 paddingTop: 8, paddingLeft: 18, paddingRight: 18)
        
        let image = UIImage(systemName: "chevron.left")
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSaveChanges))
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleShowEditProfile))
        doneButton.tintColor = .systemBlue
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    //MARK: - API
    
    func setUserInfo() {
       guard let newInfo = editInfoTextField.text else {return}
        
        if forUsersName {
            UserService.changeUser(user: user, name: newInfo)
        } else {
            UserService.changeUser(user: user, username: newInfo)
        }
    }
    
    
    //MARK: - Selectors
    
    @objc func handleSaveChanges() {
        setUserInfo()
        navigationController?.popViewController(animated: true)
        }
    
    @objc func handleShowEditProfile() {
        navigationController?.popViewController(animated: true)
    }
}
