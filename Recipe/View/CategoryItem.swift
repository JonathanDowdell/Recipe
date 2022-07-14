//
//  CategoryItem.swift
//  Recipe
//
//  Created by Mettaworldj on 7/13/22.
//

import UIKit
import Kingfisher

class CategoryItem: UICollectionViewListCell {
    
    let imageView = UIImageView(image: UIImage.emptyImage(with: .zero))
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        imageView.kf.indicatorType = .activity
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: Category) -> UIListContentConfiguration {
        var content = self.defaultContentConfiguration()
        
        let primaryText = category.strCategory
        let primaryRange = (primaryText as NSString).range(of: primaryText)
        let primaryMutableString = NSMutableAttributedString(string: primaryText)
        primaryMutableString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title3), range: primaryRange)
        content.attributedText = primaryMutableString
        
        content.image = UIImage.emptyImage(with: .init(width: 40, height: 40))
        content.imageProperties.cornerRadius = 10
        
        if let url = URL(string: category.strCategoryThumb) {
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
}
