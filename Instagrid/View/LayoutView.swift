//
//  LayoutView.swift
//  Instagrid
//
//  Created by Maxime Point on 16/07/2022.
//

import UIKit

class LayoutView: UIView {
  
  enum LayoutType {
    case OneUpTwoDown
    case TwoUpOneDown
    case TwoUpTwoDown
  }
  
  @IBOutlet var buttons: [UIButton]!

  var layoutType: LayoutType = .OneUpTwoDown {
    didSet {
      currentLayoutUpdate()
    }
  }
  
  func currentLayoutUpdate() {
    for button in buttons {
      button.isHidden = false
      
      switch layoutType {
      case .OneUpTwoDown:
        if button.tag == 4 {
          button.isHidden = true
        }
      case .TwoUpOneDown:
        if button.tag == 7 {
          button.isHidden = true
        }
      case .TwoUpTwoDown:
        print(layoutType)
      }
      
    }
  }
  
  @IBAction func addPicture(_ sender: UIButton) {
    sender.setTitle("", for: .normal)
    sender.setImage(UIImage(named: "Selected"), for: .normal)
    sender.contentVerticalAlignment = .fill
    sender.contentHorizontalAlignment = .fill
  }


}
