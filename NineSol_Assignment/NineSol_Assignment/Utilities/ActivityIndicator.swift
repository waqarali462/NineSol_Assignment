//
//  ActivityIndicator.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import Foundation
import UIKit

class ActivityIndicator: UIView {

    private static var sharedInstance: ActivityIndicator?

    private var activityIndicator: UIActivityIndicatorView!

    class func showSpinny() {
        DispatchQueue.main.async {
            if let topViewController = UIWindow.topViewController() {
                sharedInstance = ActivityIndicator(frame: topViewController.view.bounds)
                topViewController.view.addSubview(sharedInstance!)
                sharedInstance?.startAnimating()
            }
           
        }
    }

    class func hideSpinny() {
        DispatchQueue.main.async {
            sharedInstance?.stopAnimating()
            sharedInstance?.removeFromSuperview()
            sharedInstance = nil
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.cornerRadius = 10

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func startAnimating() {
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
    }

    func stopAnimating() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
    }
}
extension UIWindow {
    static func topViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
