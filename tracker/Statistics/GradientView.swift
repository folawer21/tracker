//
//  GradientView.swift
//  tracker
//
//  Created by Александр  Сухинин on 23.07.2024.
//

import UIKit

final class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    private func setupGradient() {
        gradientLayer.colors = [Colors.gradientRed?.cgColor, Colors.gradientBlue?.cgColor, Colors.gradientGreen?.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 16
        layer.insertSublayer(gradientLayer, at: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
