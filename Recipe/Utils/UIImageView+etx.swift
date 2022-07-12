//
//  UIImageView+etx.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        self.kf.setImage(with: url)
    }
}
