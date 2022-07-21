//
//  ViewController.swift
//  Instagrid
//
//  Created by Maxime Point on 15/07/2022.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var appTitle: UILabel!
  @IBOutlet weak var appSubtitle: UILabel!
  @IBOutlet weak var horizontalAppSubtitle: UILabel!
  @IBOutlet var layouts: [UIButton]!
  
  @IBOutlet weak var currentLayoutView: LayoutView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    appTitle.font = UIFont(name: "ThirstySoftRegular", size: 29)
    appSubtitle.font = UIFont(name: "Delm-Medium", size: 15)
    horizontalAppSubtitle.font = UIFont(name: "Delm-Medium", size: 15)
  }
  
  @IBAction func layoutSelection(_ sender: UIButton) {
    for layout in self.layouts {
        layout.isSelected = false
    }
    sender.isSelected = !sender.isSelected
    sender.setImage(UIImage(named: "Selected"), for: .selected)
    sender.contentVerticalAlignment = .fill
    sender.contentHorizontalAlignment = .fill
    
    if sender.tag == 0 {
      self.currentLayoutView.layoutType = .OneUpTwoDown
    } else if sender.tag == 1 {
      self.currentLayoutView.layoutType = .TwoUpOneDown
    } else {
      self.currentLayoutView.layoutType = .TwoUpTwoDown
    }
  }
  
  
  
//  func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
//    let imagePicker = UIImagePickerController()
//    imagePicker.sourceType = sourceType
//    return imagePicker
//  }
//  
//  func showImagePickerOption() {
//    let alertVC = UIAlertController(title: "Picka Photo", message: "Choose a picture from Library or camera", preferredStyle: .actionSheet)
//    
//    // Image Picker for camera
//    let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
//      guard let self = self else {
//        return
//      }
//      let cameraImagePicker = self.imagePicker(sourceType: .camera)
//      self.present(cameraImagePicker, animated: true){
//        // To do
//      }
//    }
//    
//    // Image Picker for library
//    let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
//      guard let self = self else {
//        return
//      }
//      let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
//      self.present(libraryImagePicker, animated: true){
//        // To do
//      }
//    }
//    
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//    alertVC.addAction(cameraAction)
//    alertVC.addAction(libraryAction)
//    alertVC.addAction(cancelAction)
//    self.present(alertVC, animated: true, completion: nil)
//    
//  }
  
}
