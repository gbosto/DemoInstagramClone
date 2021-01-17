//
//  UploadPostController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?
    var currentUser: User?
    private var selectedImage: UIImage?
    
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.setDimensions(height: 180, width: 180)
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemRed
        
        return view
    }()
    
    private lazy var captionTextView: InputTextView = {
        let view = InputTextView()
        view.contentMode = .scaleToFill
        view.placeholderText = "Write a caption.."
        view.font = UIFont.systemFont(ofSize: 16)
        view.delegate = self
        
        return view
    }()
    
    private let characterCountLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "0/100"
        
        return view
    }()
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedImage != nil {
        configureUI()
        } else {
            view.backgroundColor = .white
        }
    }
    
    init(selectedImage: UIImage?) {
        self.selectedImage = selectedImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Methods
    
    func configureUI() {
        configureNavigationItem()
        view.backgroundColor = .white
        
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 12)
        photoImageView.centerX(inView: view)
        photoImageView.image = selectedImage
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                               paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor,
                                   paddingBottom: -8 ,paddingRight: 12)
    }
    
    func configureNavigationItem() {
        navigationItem.title = "New Post"

        let image = UIImage(systemName: "chevron.left")
        let cancelButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapCancel))
        let shareButton = UIBarButtonItem(title: "Share", style: .done,
                                          target: self, action: #selector(didTapDone))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = shareButton
    }
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    //MARK: - Selectors
    
    @objc func didTapCancel() {
        self.delegate?.controllerDidFinishUploadingPost(self)
    }
    
    @objc func didTapDone() {
        guard let caption = captionTextView.text,
        let user = currentUser,
        let image = selectedImage else {return}
        
        showLoader(true)
        
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to upload post with error : \(error.localizedDescription)")
                return
            }
            self.delegate?.controllerDidFinishUploadingPost(self)
        }

    }

}

    //MARK: - Delegate

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
