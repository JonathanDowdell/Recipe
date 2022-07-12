//
//  Meal.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import Foundation

struct Meal: Codable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}

extension Meal: Hashable {}
