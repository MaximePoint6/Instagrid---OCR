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
    
    enum ImageButtonPosition: Int {
        case TopLeft = 4
        case TopRight = 5
        case BottomLeft = 6
        case BottomRight = 7
    }
    
    @IBOutlet var Imagesbuttons: [UIButton]!
    
    var layoutType: LayoutType = .OneUpTwoDown {
        didSet {
            currentLayoutUpdate()
        }
    }
    
    func currentLayoutUpdate() {
        for button in Imagesbuttons {
            button.isHidden = false
            switch layoutType {
            case .OneUpTwoDown:
                if button.tag == ImageButtonPosition.TopRight.rawValue {
                    button.isHidden = true
                }
            case .TwoUpOneDown:
                if button.tag == ImageButtonPosition.BottomRight.rawValue {
                    button.isHidden = true
                }
            case .TwoUpTwoDown: break
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
