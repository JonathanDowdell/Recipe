//
//  Category.swift
//  Recipe
//
//  Created by Mettaworldj on 7/13/22.
//

import Foundation

struct CategoryWrapper: Codable {
    let categories: [Category]
}

extension CategoryWrapper: Hashable {}

struct Category: Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

extension Category: Hashable {}
