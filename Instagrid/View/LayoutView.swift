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
}

extension UIView {
    func asImage() -> UIImage {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
    }
}
