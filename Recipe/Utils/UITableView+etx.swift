//
//  UITableView+etx.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit

extension UITableView {
    func deselectSelectedRow(animated: Bool) {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            self.deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }
}
