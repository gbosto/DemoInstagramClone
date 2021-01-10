//
//  MainTabController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    
    //MARK: - Lifecycle
    var user: User? {
        didSet {
            guard let user = self.user else {return}
            configureViewControllers(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    //MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
            }
        }
    
    
    
    
    //MARK: - Helper Methods
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            
            self.present(navigationController, animated: true)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        tabBar.tintColor = .black
    }
    
    func configureViewControllers(withUser user: User) {
        
        self.delegate = self
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"),
                                                rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"),
                                                  rootViewController: SearchController())
        
        let uploadPost = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"),
                                                         rootViewController: UploadPostController(selectedImage: nil))
        
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"),
                                                         rootViewController: NotificationsController())
        let profileController = ProfileController(user: user)
        profileController.delegate = self
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"),
                                                   rootViewController: profileController)
        
        viewControllers = [feed, search, uploadPost, notifications, profile]
    }
    
    func templateNavigationController(unselectedImage: UIImage,
                                      selectedImage: UIImage,
                                      rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.tintColor = .black
        
        return navigationController
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else {return}
                
                let controller = UploadPostController(selectedImage: selectedImage)
                controller.delegate = self
                controller.currentUser = self.user
                
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                
                self.present(nav, animated: false)
            }
        }
    }
}

//MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func AuthenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true)
    }
}

//MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)

        if index == 2 {
            var configuration = YPImagePickerConfiguration()
            configuration.library.mediaType = .photo
            configuration.shouldSaveNewPicturesToAlbum = true
            configuration.startOnScreen = .library
            configuration.screens = [.library, .photo]
            configuration.hidesStatusBar = false
            configuration.hidesBottomBar = false
            configuration.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: configuration)
            picker.modalPresentationStyle = .fullScreen
            
            present(picker, animated: true)
            
            didFinishPickingMedia(picker)
        }
        
        return true
    }
}

//MARK: - UploadPostControllerDelegate

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true)
        guard let feedNav = viewControllers?.first as? UINavigationController,
              let feed = feedNav.viewControllers.first as? FeedController else {return}
                feed.handleRefresh()
    }
}

extension MainTabController: ProfileControllerDelegate {
    func controllerWantsToLogout() {
        
        let alert = UIAlertController(title: "Log out?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let LogoutAction = UIAlertAction(title: "Logout", style: .default) { _ in
            self.selectedIndex = 0
            do {
                try Auth.auth().signOut()
                self.presentLoginController()
            } catch {
                print("DEBUG: Failed to sign out")
            }
        }
        alert.addAction(LogoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
