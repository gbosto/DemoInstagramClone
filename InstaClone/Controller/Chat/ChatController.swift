//
//  ChatController.swift
//  InstaClone
//
//  Created by Giorgi on 1/15/21.
//

import UIKit

class ChatController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let cellId = "ChatCell"
    private let user: User
    private var messages = [Message]()
    
    override var  inputAccessoryView: UIView? {
        get {return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    private lazy var customInputView: CostumInputAccessoryView = {
        let view = CostumInputAccessoryView(placeholderTitle: "Enter message", buttonTitle: "Send",
                                            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.delegate = self
        
        return view
    }()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func fetchMessages() {
        showLoader(true)
        ChatService.fetchMessages(forUser: user) { messages in
            self.showLoader(false)
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }
        self.showLoader(false)
    }
    
    //MARK: - Helper Methods
    
    func configureUI() {
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        
        collectionView.keyboardDismissMode = .interactive
    }
    
    //MARK: - Selectors
 
}

//MARK: - DataSource

    extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

    extension ChatController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}


//MARK: - CostumInputAccessoryViewDelegate

extension ChatController: CostumInputAccessoryViewDelegate {
    func inputView(_ inputView: CostumInputAccessoryView, wantsToUploadInput input: String) {
        ChatService.uploadMessage(input, to: user) { error in
            if let error = error {
                print("DEBUG: Failed to upload message with error \(error.localizedDescription)")
            }
        }
        inputView.clearInputTextView()
    }
}
