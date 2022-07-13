//
//  RecipeIngredientItem.swift
//  Recipe
//
//  Created by Mettaworldj on 7/13/22.
//

import UIKit

class RecipeIngredientItem: UICollectionViewListCell {
    func configure(with ingredient: Ingredient) -> UIListContentConfiguration {
        var content = self.defaultContentConfiguration()
        content.text = ingredient.ingredient
        content.secondaryText = ingredient.measurement
        return content
    }
}
