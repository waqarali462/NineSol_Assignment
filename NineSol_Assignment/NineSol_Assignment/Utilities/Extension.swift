//
//  Extension.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import Foundation
import UIKit
extension UIViewController {
    static func loadFromNib(_ xibFileName:String? = nil) -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: xibFileName != nil ? xibFileName! : String(describing:T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    func addChildViewController(_ childController: UIViewController, to containerView: UIView) {
        addChild(childController)
        containerView.addSubview(childController.view)
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        childController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        childController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        childController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        childController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        childController.didMove(toParent: self)
    }
}
