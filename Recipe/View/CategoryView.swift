//
//  CategoryView.swift
//  Recipe
//
//  Created by Mettaworldj on 7/13/22.
//

import UIKit

class CategoryView: UIView {
    lazy var collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = UICollectionLayoutListConfiguration.HeaderMode.supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.keyboardDismissMode = .onDrag
        
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = .red
    }
    
    func setupSubviews() {
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
