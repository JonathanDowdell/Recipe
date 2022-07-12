//
//  MealItem.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit

class MealItem: UICollectionViewListCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(with meal: Meal) -> UIListContentConfiguration {
        var content = self.defaultContentConfiguration()
        content.text = meal.strMeal
        content.secondaryText = meal.idMeal
        return content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
