//
//  Animations.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.
//

import Foundation
import UIKit

// MARK: - Animastion for new Views
public class Animations {
  static func show(view: UIView) {
    let window = UIApplication.shared.connectedScenes
      .filter({$0.activationState == .foregroundActive})
      .map({$0 as? UIWindowScene})
      .compactMap({$0})
      .first?.windows
      .filter({$0.isKeyWindow}).first
    window?.addSubview(view)
    view.pinEdgesToSuperView()
  }
  
  static func showFade(view: UIView) {
    view.alpha = 0.0
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      UIView.animate(withDuration: 1.0, animations: {
        view.alpha = 1.0
      })
    }
  }
  
  static func dismiss(view: UIView) {
    let duration = 2.0
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      UIView.animate(withDuration: 1.5, animations: {
        view.alpha = 0.0
      })
    }
  }
  
  static func scaleWhenScrolling(view: UIView, isScrolling: Bool) {
    UIView.animate(withDuration: 0.25, animations: { () -> Void in
      let scale: CGFloat = 0.80
      if isScrolling {
        view.transform = CGAffineTransform(scaleX: scale, y: scale)
      } else {
        view.transform = CGAffineTransform.identity
      }
    })
  }
    
    func showSimpleAlert(title: String,
                         message: String,
                         style: UIAlertController.Style = .alert) -> UIAlertController {
      let alert = UIAlertController(title: title, message: message, preferredStyle: style)
      alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: { _ in
        //Cancel Action
      }))
      return alert
    }
}

