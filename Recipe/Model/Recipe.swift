//
//  Recipe.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import Foundation

struct RecipeWrapper: Decodable {
    var meals: [Recipe]?
    var data: Data?
}

extension RecipeWrapper: Hashable {}

struct Recipe: Decodable {
    var idMeal: String?
    var strMeal: String?
    var strDrinkAlternate: String?
    var strCategory: String?
    var strArea: String?
    var strInstructions: String?
    var strMealThumb: String?
    var strTags: String?
    var strYoutube: String?
    var strSource: String?
    var strImageSource: String?
    var strCreativeCommonsConfirmed: String?
    var ingredients: [Ingredient]? = .init()
    var dateModified: String?
}

extension Recipe: Hashable {}

