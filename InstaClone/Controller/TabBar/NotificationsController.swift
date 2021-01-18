//
//  NotificationsController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//


import Firebase

 class NotificationsController: UITableViewController {
    
    //MARK: - Properties
    
    private let cellId = "NotificationsCell"
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let refresher = UIRefreshControl()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotification{ notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed()
        }
    }
    
    func checkIfUserIsFollowed() {
        notifications.forEach { notification in
            guard notification.type == .follow else {return}
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id}) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    //MARK: - Helper Methods
    func configureUI() {
        tableView.backgroundColor = .white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher

    }
    
    //MARK: - Selectors
    
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
    
 }

    //MARK: - Data Source
    
extension NotificationsController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NotificationCell
        let notification = notifications[indexPath.row]
        
        UserService.fetchUser(withUid: notification.uid) { user in
            cell.viewModel = NotificationViewModel(notification: notification, user: user)
        }
        cell.delegate = self
        
        return cell
    }
}
    
    //MARK: - Delegate
    
extension NotificationsController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        let uid = notifications[indexPath.row].uid
        
        UserService.fetchUser(withUid: uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
       guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        showLoader(true)
        
        UserService.fetchUser(withUid: currentUserUid) { currentUser in
            UserService.follow(uid: uid) { _ in
                self.showLoader(false)
                cell.viewModel?.notification.userIsFollowed.toggle()
                NotificationService.uploadNotification(toUid: uid, fromUser: currentUser, type: .follow)
            }
        }
        UserService.fetchUser(withUid: uid) { user in
            PostService.updateUserFeedAfterFollowing(user: user, didFollow: true)
        }

    }
    
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        showLoader(true)
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
        UserService.fetchUser(withUid: uid) { user in
            PostService.updateUserFeedAfterFollowing(user: user, didFollow: false)
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        showLoader(true)
        
        NotificationService.checkIfPostStillExists(postId: postId) { stillExists in
            if !stillExists {
                self.showLoader(false)
                self.showMessage(withTitle: "Error", message: "Post Doesn's exist", dissmissalText: "OK")
                return
                }
            }
        
        PostService.fetchPost(withPostId: postId) { post in
            self.showLoader(false)
            let layout = UICollectionViewFlowLayout()
            let controller = FeedController(collectionViewLayout: layout )
            controller.post = post
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}
