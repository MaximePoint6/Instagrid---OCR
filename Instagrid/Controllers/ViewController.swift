//
//  ViewController.swift
//  Instagrid
//
//  Created by Maxime Point on 15/07/2022.
//

import UIKit
import AVFoundation
import Photos
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appSubtitle: UILabel!
    @IBOutlet weak var horizontalAppSubtitle: UILabel!
    @IBOutlet var layoutsButtons: [UIButton]!
    @IBOutlet weak var gridView: GridView!
    var layoutButtonClicked: UIButton!
    var orientation: Orientation = .portrait
    let negativeTranslationToShare: CGFloat = -150
    var imageToShare = false
    
    enum Orientation {
        case landscape
        case portrait
    }
    
    enum LayoutTypeButton: Int {
        case OneUpTwoDown = 1
        case TwoUpOneDown = 2
        case TwoUpTwoDown = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizerUp = UIPanGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        gridView.addGestureRecognizer(swipeGestureRecognizerUp)
    }
    
    //MARK: DEvice orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        orientation = UIDevice.current.orientation.isLandscape ? .landscape : .portrait
    }
    
    //MARK: UI
    /// Function updating the UI, in particular the font.
    private func setupUI() {
        appTitle.font = UIFont(name: "ThirstySoftRegular", size: 30)
        appSubtitle.font = UIFont(name: "Delm-Medium", size: 20)
        horizontalAppSubtitle.font = UIFont(name: "Delm-Medium", size: 20)
    }
    
    /// Function modifying the UI when selecting the layout button and changing the layout type of the gridView
    /// - Parameter sender: Button selected to change layout
    @IBAction func layoutSelection(_ sender: UIButton) {
        _ = self.layoutsButtons.map { $0.isSelected = false } // replace the loop "for"
        sender.isSelected = !sender.isSelected
        sender.setImage(UIImage(named: "Selected"), for: .selected)
        sender.contentVerticalAlignment = .fill
        sender.contentHorizontalAlignment = .fill
        
        if sender.tag == LayoutTypeButton.OneUpTwoDown.rawValue {
            self.gridView.layoutType = .OneUpTwoDown
        } else if sender.tag == LayoutTypeButton.TwoUpOneDown.rawValue {
            self.gridView.layoutType = .TwoUpOneDown
        } else {
            self.gridView.layoutType = .TwoUpTwoDown
        }
    }
    
    /// Function launching the procedure for adding a photo.
    /// - Parameter sender: Button selected to add a photo
    @IBAction func addPicture(_ sender: UIButton) {
        layoutButtonClicked = sender
        showImagePickerOption()
    }
    
    //MARK: ImagePicker
    /// Function displaying a popup to choose the source (library or camera) in order to add an image.
    private func showImagePickerOption() {
        let alertVC = UIAlertController(title: "Pick a Photo", message: "Choose a picture from Library or camera", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.cameraAuthorization()
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { _ in
            self.photosAutorization()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// Function verifying and/or requesting authorizations for the use of the camera
    private func cameraAuthorization() {
        // Authorization for Camera
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            present(cameraImagePicker, animated: true){}
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        let cameraImagePicker = self.imagePicker(sourceType: .camera)
                        cameraImagePicker.delegate = self
                        self.present(cameraImagePicker, animated: true){}
                    }
                }
            }
        case .denied: // The user has previously denied access.
            let alert = UIAlertController(title: "Setting", message: "This app is not authorized to use Camera. Please allow the app to use the camera in settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { _ in
                DispatchQueue.main.async {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        case .restricted: // The user can't grant access due to restrictions.
            return
        @unknown default:
            fatalError()
        }
    }
    
    /// Function verifying and/or requesting authorizations for the use of the library
    private func photosAutorization(){
        // Authorization for Photos
        var authorizationStatus : PHAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            authorizationStatus = PHPhotoLibrary.authorizationStatus()
        }
        switch authorizationStatus {
        case .authorized: // The user has previously granted access to the photo.
            let imagePicker = self.imagePicker(sourceType: .photoLibrary)
            imagePicker.delegate = self
            present(imagePicker, animated: true){}
        case .limited:
            let imagePicker = self.imagePicker(sourceType: .photoLibrary)
            imagePicker.delegate = self
            present(imagePicker, animated: true){}
        case .notDetermined: // The user has not yet been asked for photos access.
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    DispatchQueue.main.async{
                        if status == .authorized {
                            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
                            libraryImagePicker.delegate = self
                            self.present(libraryImagePicker, animated: true){}
                        } else if status == .limited {
                            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
                            libraryImagePicker.delegate = self
                            self.present(libraryImagePicker, animated: true){}
                        }
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization(){ status in
                    if status == .authorized {
                        let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
                        libraryImagePicker.delegate = self
                        self.present(libraryImagePicker, animated: true){}
                    }
                }
            }
        case .denied: // The user has previously denied access.
            let alert = UIAlertController(title: "Setting", message: "This app is not authorized to use Photos. Please allow the app to use photos in settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        case .restricted: // The user can't grant access due to restrictions.
            return
        @unknown default:
            fatalError()
        }
    }
    
    private func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    //MARK: Swipe up and Swipe left
    /// Function managing the swipe and the resulting actions from it according to the status.
    /// - Parameter sender: UIPanGestureRecognizer
    @objc private func didSwipe(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            transformLayoutView(gesture: sender)
        case .ended, .cancelled:
            animationLayoutView()
        default:
            break
        }
    }
    
    //MARK: Transform, Animation and Reset Layout View
    /// Function managing the translation of the gridView during the swipe
    /// - Parameter gesture: UIPanGestureRecognizer
    private func transformLayoutView(gesture: UIPanGestureRecognizer) {
        // Translation
        var translation = gesture.translation(in: gridView)
        switch orientation {
        case .portrait:
            if translation.y >= 0 {
                translation.y = 0 // so we can't slide down
            } else {
                let translationTransform = CGAffineTransform(translationX: 0, y: translation.y)
                gridView.transform = translationTransform
            }
            imageToShare = translation.y <= negativeTranslationToShare ? true : false
        case .landscape:
            if translation.x >= 0 {
                translation.x = 0 // so we can't slide to the right
            } else {
                let translationTransform = CGAffineTransform(translationX: translation.x, y: 0)
                gridView.transform = translationTransform
            }
            imageToShare = translation.x <= negativeTranslationToShare ? true : false
        }
    }
    
    /// Function performing the animation allowing the gridView to exit outside the screen.
    private func animationLayoutView() {
        // Animation Question View
        if imageToShare == false {
            resetLayoutView()
        } else {
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            let translationTransform: CGAffineTransform
            switch orientation {
            case .landscape:
                translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
            case .portrait:
                translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = translationTransform
            }, completion: { (success) in
                if success {
                    self.picturesharing()
                }
            })
        }
    }
    
    /// Function performing the animation allowing to return the gridView to the initial position.
    private func resetLayoutView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = .identity
        }, completion:nil)
    }
    
    //MARK: picture sharing
    /// Function transforming GridView into an image then launching a window to share this image.
    private func picturesharing(){
        let items = [self.gridView.asImage()]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true, completion: nil)
        ac.completionWithItemsHandler = { activity, success, items, error in
            self.resetLayoutView()
        }
        imageToShare = false
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.layoutButtonClicked.setImage(image, for: .normal)
        self.layoutButtonClicked.setTitle("", for: .normal)
        layoutButtonClicked.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        self.dismiss(animated: true, completion: nil)
    }
}
