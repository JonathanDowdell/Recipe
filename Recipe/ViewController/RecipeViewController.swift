//
//  RecipeViewController.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit

class RecipeViewController: UIViewController {
    
    let meal: Meal
    var recipe: Recipe?
    
    private let mainView = RecipeView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let network: NetworkProtocol
    
    private var ingredients: [Ingredient] {
        return (recipe?.ingredients ?? .init()).sorted { $0.ingredient < $1.ingredient }
    }
    
    init(
        meal: Meal,
        network: NetworkProtocol = DefaultNetworkService.shared
    ) {
        self.meal = meal
        self.network = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = meal.strMeal
        self.navigationController?.title = meal.strMeal
        setupCollectionView()
        getRecipe()
    }
    
    fileprivate func getRecipe() {
        let recipeRequest = RecipeRequest(apiKey: "1", recipeId: meal.idMeal)
        Task {
            let recipe = (try await network.request(recipeRequest).meals ?? .init()).first
            await MainActor.run {
                self.recipe = recipe
                self.applySnapshot()
            }
        }
    }
    
    fileprivate func setupCollectionView() {
        self.mainView.collectionView.delegate = self
        
        let imageRegistration = UICollectionView.CellRegistration<RecipeImageItem, Meal> {
            cell, indexPath, meal in
            let content = cell.configure(with: meal)
            cell.contentConfiguration = content
        }
        
        let instructionsRegistration = UICollectionView.CellRegistration<RecipeInstructionsItem, Recipe> {
            cell, indexPath, recipe in
            let content = cell.configure(with: recipe)
            cell.contentConfiguration = content
        }
        
        let ingredientsRegistration = UICollectionView.CellRegistration<RecipeIngredientItem, Ingredient> {
            cell, indexPath, ingredient in
            let content = cell.configure(with: ingredient)
            cell.contentConfiguration = content
        }
        
        let blankHeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionReusableView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, string, indexPath in }
        
        let instructionHeaderRegistration = UICollectionView.SupplementaryRegistration<RecipeSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, string, indexPath in
            supplementaryView.titleLabel.text = "Instructions"
        }
        
        let ingredientsHeaderRegistration = UICollectionView.SupplementaryRegistration<RecipeSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, string, indexPath in
            supplementaryView.titleLabel.text = "Ingredients"
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: mainView.collectionView) {
            collectionView, indexPath, item in
            
            switch Section(rawValue: indexPath.section) {
            case .image:
                return collectionView.dequeueConfiguredReusableCell(using: imageRegistration, for: indexPath, item: item as? Meal)
            case .instruction:
                return collectionView.dequeueConfiguredReusableCell(using: instructionsRegistration, for: indexPath, item: item as? Recipe)
            case .ingredient:
                return collectionView.dequeueConfiguredReusableCell(using: ingredientsRegistration, for: indexPath, item: item as? Ingredient)
            }
        }
        
        dataSource?.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            switch Section(rawValue: indexPath.section) {
            case .image:
                return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: blankHeaderRegistration, for: indexPath)
            case .instruction:
                return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: instructionHeaderRegistration, for: indexPath)
            case .ingredient:
                return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: ingredientsHeaderRegistration, for: indexPath)
            }
        }
    }
    
    fileprivate func applySnapshot(animatingDifferences: Bool = true) {
        if let recipe = recipe {
            var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snapshot.appendSections([.image, .instruction, .ingredient])
            for section in Section.allCases {
                switch section {
                case .image:
                    snapshot.appendItems([meal], toSection: .image)
                case .instruction:
                    snapshot.appendItems([recipe], toSection: .instruction)
                case .ingredient:
                    snapshot.appendItems(ingredients, toSection: .ingredient)
                }
            }
            self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}

extension RecipeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Vibration.light.vibrate()
        
        switch Section(rawValue: indexPath.section) {
        case .image:
            let copiedValue = recipe?.strInstructions
            UIPasteboard.general.string = copiedValue
        case .instruction:
            let copiedValue = recipe?.strInstructions
            UIPasteboard.general.string = copiedValue
        case .ingredient:
            let copiedValue = ingredients[indexPath.item].ingredient
            UIPasteboard.general.string = copiedValue
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension RecipeViewController {
    enum Section: Int, CaseIterable {
        case image
        case instruction
        case ingredient
        
        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .image
            case 1: self = .instruction
            case 2: self = .ingredient
            default:
                self = .instruction
            }
        }
    }
}
