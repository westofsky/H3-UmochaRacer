//
//  UIView+.swift
//  iOS_H3
//
//  Created by KoJeongMin  on 2023/08/14.
//

import UIKit

extension UIView {
    func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
           self.addSubview(activityIndicator)
           activityIndicator.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
               activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
           ])
           activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        self.subviews.forEach {
            if $0 is UIActivityIndicatorView {
                $0.removeFromSuperview()
            }
        }
    }

    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
