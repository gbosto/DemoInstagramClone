//
//  Extensions.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    
    func configureSearchController(searchController: UISearchController) {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
    }
    
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            if show {
                UIViewController.hud.show(in: self.view)
            } else {
                UIViewController.hud.dismiss()
            }
        }
    }
    
    func showMessage(withTitle title: String, message: String, dissmissalText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dissmissalText, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self,
                                                                  action: #selector(handleDismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
     @objc private func handleDismissKeyboard(){
        view.endEditing(true)
    }
    
    
    func configureImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        
        let alert = UIAlertController(title: "Choose Your Profile Picture", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        let fromCameraAction = UIAlertAction(title: "Take Picture", style: .default) { [weak self] _ in
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.cameraDevice = .front
            imagePicker.showsCameraControls = true
            imagePicker.isNavigationBarHidden = false
            imagePicker.isToolbarHidden = true
            
            self?.present(imagePicker, animated: true, completion: nil)
        }
        
        let fromLlibraryAction = UIAlertAction(title: "Choose From Library", style: .default) { [weak self] _ in
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            
            self?.present(imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(fromCameraAction)
        alert.addAction(fromLlibraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        return imagePicker
    }
}

extension UIButton {
    func attributedTitle(firstPart: String, secondPart: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "\(firstPart) ", attributes: atts)
        
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}


extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
