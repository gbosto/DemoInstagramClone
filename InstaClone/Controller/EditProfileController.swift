//
//  File.swift
//  InstaClone
//
//  Created by Giorgi on 1/12/21.
//

import UIKit

class EditProfileController: UIViewController {
    
        
    //MARK: - Properties
    
    
    private var profileImage: UIImage?
    private var user: User
    
    private lazy var editProfileView = EditProfileView(frame: CGRect(x: 0, y: 0,
                                                                width: view.bounds.width, height: 300))
    
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.crop.circle.fill")
        view.tintColor = .lightGray
        view.clipsToBounds = true
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
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUser()
    }
        
        init(user: User) {
            self.user = user
            super.init(nibName: nil, bundle: nil)
        }
    
        required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    
        //MARK: - API
    
    func updateProfileImage() {
        guard let image = profileImage else {return}
        ImageService.deleteImage(withUid: user.profileImageUid, directory: FireStoreDirectory.profileImages) { error in
            print(self.user.profileImageUid)
            if let error = error {
                print("DEBUG: Error while deleting profile picture \(error.localizedDescription)")
            }

            let uuid = NSUUID().uuidString
            ImageService.uploadImage(image: image, uuid: uuid, directory: FireStoreDirectory.profileImages) { imageUrl in
                UserService.changeUsersProfileImageUrl(user: self.user, url: imageUrl)
            }
        }
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
            
            view.addSubview(editProfileView)
            editProfileView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                   paddingTop: 12, paddingLeft: 32, paddingRight: 32)
            editProfileView.delegate = self
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSaveChanges))
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
            doneButton.tintColor = .systemBlue
            
            navigationItem.rightBarButtonItem = doneButton
            navigationItem.leftBarButtonItem = cancelButton
        }
    
        //MARK: - API
    func fetchUser(){
        UserService.fetchUser(withUid: user.uid) { user in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.editProfileView.usersNameLabel.text = user.fullname
                self.editProfileView.usersUsernameLabel.text = user.username
                let url = URL(string: user.profileImageUrl)
                self.profileImageView.sd_setImage(with: url)
                self.user = user
            }
        }
    }
    

        //MARK: - Selectors
    @objc func handleProfilePhotoSelect() {
            let picker = configureImagePicker()
            picker.delegate = self
    }
     
    @objc func handleSaveChanges() {
        updateProfileImage()
        navigationController?.popViewController(animated: true)
        }
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
        }
    }

        //MARK: - Delegate

extension EditProfileController: EditProfileViewDelegate {
    func viewWantsToEditName(_ view: EditProfileView) {
        let title = "name"
        let controller = EditInfoController(title: title, user: user, forUsersName: true)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func viewWantsToEditUserName(_ view: EditProfileView) {
        let title = "username"
        let controller = EditInfoController(title: title, user: user, forUsersName: false)
        navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK: - UIImagePickerControllerDelegate && UINavigationControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
func imagePickerController(_ picker: UIImagePickerController,
                           didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let image = info[.editedImage] as? UIImage else {return}
    profileImage = image
    profileImageView.image = image
    
    profileImageView.layer.masksToBounds = true
    profileImageView.layer.borderColor = UIColor.white.cgColor
    profileImageView.layer.borderWidth = 2
    profileImageView.image = image.withRenderingMode((.alwaysOriginal))
            
    picker.dismiss(animated: true, completion: nil)
    
}
}
