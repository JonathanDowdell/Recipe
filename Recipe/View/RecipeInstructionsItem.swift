//
//  RecipeInstructionsItem.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit

class RecipeInstructionsItem: UICollectionViewListCell {
    func configure(with recipe: Recipe) -> UIListContentConfiguration {
        var content = self.defaultContentConfiguration()
        content.text = recipe.strInstructions ?? ""
        return content
    }
}
