//
//  RecipeImageItem.swift
//  Recipe
//
//  Created by Mettaworldj on 7/13/22.
//

import UIKit
import Kingfisher

class RecipeImageItem: UICollectionViewListCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with meal: Meal) -> UIListContentConfiguration {
        var content = self.defaultContentConfiguration()
        content.image = UIImage.emptyImage(with: .init(width: 150, height: 150))
        content.imageProperties.cornerRadius = 10
        if let url = URL(string: meal.strMealThumb) {
            imageView.kf.setImage(with: url, options: [
                .cacheOriginalImage,
                .scaleFactor(UIScreen.main.scale)
            ]) { result in
                self.imageView.contentMode = .center
                UIView.animate(withDuration: 0.5) {
                    self.imageView.alpha = 1
                }
            }
        }
        return content
    }
}
