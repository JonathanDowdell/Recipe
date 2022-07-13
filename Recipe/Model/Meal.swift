//
//  Meal.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import Foundation

struct MealsWrapper: Codable {
    var meals: [Meal]
}

extension MealsWrapper: Hashable {}

struct Meal: Codable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}

extension Meal: Hashable {}
