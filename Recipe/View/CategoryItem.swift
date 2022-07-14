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

extension NSAttributedString {

    func numberOfLines(with width: CGFloat) -> Int {

        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        let frameSetterRef : CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)

        let linesNS: NSArray  = CTFrameGetLines(frameRef)

        guard let lines = linesNS as? [CTLine] else { return 0 }
        return lines.count
    }
}

extension String {
    enum TruncationPosition {
        case head
        case middle
        case tail
    }

    func truncated(limit: Int, position: TruncationPosition = .tail, leader: String = "...") -> String {
        guard self.count > limit else { return self }

        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit - leader.count) / 2.0))

            let tailCharactersCount = Int(floor(Float(limit - leader.count) / 2.0))
            
            return "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            return self.prefix(limit) + leader
        }
    }
    
    func limitNumLines(_ msg: String, max: Int) -> String{
        if max <= 0 { return "" }
        
        let lines = msg.components(separatedBy: "\n")
        
        var output = ""
        for i in 0..<max {
            output += lines[i] + "\n"
        }
        return output
    }
}
