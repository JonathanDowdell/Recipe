//
//  MealItem.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit
import Kingfisher

class MealItem: UICollectionViewListCell {
    
    let imageView = UIImageView(image: UIImage.emptyImage(with: .zero))
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.alpha = 0
        imageView.kf.indicatorType = .activity
        self.addSubview(imageView)
    }
    
    func configure(with meal: Meal) -> UIListContentConfiguration {
        var content = self.defaultContentConfiguration()
        content.text = meal.strMeal
        content.secondaryText = meal.idMeal
        content.image = UIImage.emptyImage(with: .init(width: 30, height: 30))
        content.imageProperties.cornerRadius = 10
        
        if let url = URL(string: meal.strMealThumb) {
            imageView.kf.setImage(with: url, options: [
                .cacheOriginalImage,
                .scaleFactor(UIScreen.main.scale)
            ]) { result in
                UIView.animate(withDuration: 0.5) {
                    self.imageView.alpha = 1
                }
            }
        }
        
        return content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
