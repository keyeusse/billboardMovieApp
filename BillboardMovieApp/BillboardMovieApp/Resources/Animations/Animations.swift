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

/*
 Class to animate a new view maked programmatically
 */
 class CreationViewAnimation: NSObject {
  enum CircularTransitionMode:Int {
    case present, dismiss, pop
  }
  var duration = 0.3
  var newView = UIView()
  var newViewColor = UIColor.green
  var transition: CircularTransitionMode = .present
  var appearPoint = CGPoint.zero {
    didSet {
        newView.center = appearPoint
    }
  }
}
extension CreationViewAnimation: UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    if transition == .present {
      if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
        let viewCenter = presentedView.center
        let viewSize = presentedView.frame.size
        
        newView = UIView()
        newView.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: appearPoint)
        newView.layer.cornerRadius = newView.frame.size.height
        newView.center = appearPoint
        newView.backgroundColor = newViewColor
        newView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        containerView.addSubview(newView)
        
        presentedView.center = appearPoint
        presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        presentedView.alpha = 0
        containerView.addSubview(presentedView)
        
        UIView.animate(withDuration: duration, animations: {
          self.newView.transform = CGAffineTransform.identity
          presentedView.transform = CGAffineTransform.identity
          presentedView.alpha = 1
          presentedView.center = viewCenter
        }, completion: { (success:Bool) in
          transitionContext.completeTransition(success)
        })
      }
    } else {
      
      let transitionModeKey = (transition == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
      if let returningView = transitionContext.view(forKey: transitionModeKey) {
        let viewCenter = returningView.center
        let viewSize = returningView.frame.size
        
        newView.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: appearPoint)
        newView.layer.cornerRadius = newView.frame.size.height
        newView.center = appearPoint
        
        UIView.animate(withDuration: duration, animations: {
          self.newView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
          returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
          returningView.center = self.appearPoint
          returningView.alpha = 0
          
          if self.transition == .pop {
            containerView.insertSubview(returningView, belowSubview: returningView)
            containerView.insertSubview(self.newView, belowSubview: returningView)
          }
        }, completion: { (success:Bool) in
          returningView.center = viewCenter
          returningView.removeFromSuperview()
          self.newView.removeFromSuperview()
          transitionContext.completeTransition(success)
        })
      }
    }
  }
  
  func frameForCircle (withViewCenter viewCenter:CGPoint, size viewSize:CGSize, startPoint:CGPoint) -> CGRect {
    let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
    let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
    let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
    let size = CGSize(width: offestVector, height: offestVector)
    return CGRect(origin: CGPoint.zero, size: size)
  }
}
