//
//  CardView.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var makeRounded: Bool = false {
        didSet {
            if makeRounded {
                layer.cornerRadius = 0.5 * bounds.size.height
            } else {
                layer.cornerRadius = cornerRadius
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }

    private func setupView() {
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4.0
        backgroundColor = UIColor.white
        if makeRounded {
            layer.cornerRadius = 0.5 * bounds.size.height
        } else {
            layer.cornerRadius = cornerRadius
        }
    }
}

