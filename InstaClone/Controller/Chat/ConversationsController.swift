//
//  ConversationsController.swift
//  InstaClone
//
//  Created by Giorgi on 1/15/21.
//


import UIKit

class ConversationsController: UITableViewController {
    
    //MARK: - Properties
    private lazy var headerView = ConversationsHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
    private let cellId = "ConversationCell"
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK: - Helper Methods
    
    func configureUI() {
        tabBarController?.tabBar.isHidden = true
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(ConversationCell.self, forCellReuseIdentifier: cellId)
    }
    
    //MARK: - API
    func fetchConversations(){
        showLoader(true)
        ChatService.fetchConversations { conversations in
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
            }
            self.showLoader(false)
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
        self.showLoader(false)
    }
    
    //MARK: - Selectors
}

//MARK: - TableView DataSource

extension ConversationsController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationCell
        let conversation = conversations[indexPath.row]
        let viewModel = ConversationViewModel(conversation: conversation)
        cell.viewModel = viewModel
        
        return cell
    }
}


//MARK: - TableView Delegate

extension ConversationsController{
   override func tableView(_ tableView: UITableView,
                           didSelectRowAt indexPath: IndexPath) {
    
        let user = conversations[indexPath.row].user
        let controller = ChatController(user: user)
    DispatchQueue.main.async { [weak self] in
        guard let self = self else {return}
        self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


//MARK: - ConversationsHeaderDelegate


extension ConversationsController: ConversationsHeaderDelegate {
    func headerWantsToShowNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func headerWantsToCloseChat() {
        navigationController?.popViewController(animated: true)
    }
}


//MARK: - NewMessageControllerDelegate

extension ConversationsController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantsToChatWith user: User) {
        navigationController?.popViewController(animated: true)
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
