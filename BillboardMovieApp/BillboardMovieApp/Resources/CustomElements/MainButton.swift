//
//  CustomUIElements.swift
//BillboardMovieApp
//
//  Created by Meli on 9/26/21.

import UIKit

@IBDesignable class RoundButton: UIButton {

    private let customBGColor: UIColor = UIColor.blue
  @IBInspectable var cornerRadius: CGFloat = 15 {
    didSet {
        setCorners(value: cornerRadius)
    }
  }

  @IBInspectable var backgroundImageColor: UIColor = UIColor.blue {
    didSet {
        mainColor(color: customBGColor)
    }
  }
    
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setCorners(value: cornerRadius)
    mainColor(color: backgroundImageColor)
  }
  
  func setCorners(value: CGFloat) {
    layer.cornerRadius = value
  }
    
  func mainColor(color: UIColor, for state:  UIControl.State = .normal) {
    let image = setImage(color: color)
    setBackgroundImage(image, for: state)
    clipsToBounds = true
  }

  private func setImage(color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
    color.setFill()
    UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
    return image
  }
}
