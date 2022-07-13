//
//  MealsViewController.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit

class MealsViewController: UIViewController {
    
    private let mealsView = MealsView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Meal>?
    private var mealList: [Meal] = .init()
    private var selectedIndexPath: IndexPath?
    private lazy var searchBar = UISearchBar(frame: .zero)
    
    override func loadView() {
        super.loadView()
        self.view = mealsView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deselectItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = UISearchController()
        self.navigationItem.searchController?.searchResultsUpdater = self
        setupCollectionView()
        getMeals()
    }
    
    fileprivate func getMeals() {
        let mealRequest = MealsRequest(apiKey: "1", category: "Dessert")
        DefaultNetworkService().request(mealRequest) { [weak self] result in
            switch result {
            case .success(let response):
                let meals = response.meals.sorted { $0.strMeal < $1.strMeal }
                self?.mealList = meals
                DispatchQueue.main.async {
                    self?.applySnapshot(with: meals)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func setupCollectionView() {
        self.mealsView.collectionView.delegate = self
        
        let registration = UICollectionView.CellRegistration<MealsViewItem, Meal> { cell, indexPath, meal in
            let content = cell.configure(with: meal)
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Meal>(collectionView: mealsView.collectionView) {
            cv, indexPath, meal in
            return cv.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: meal)
        }
    }
    
    fileprivate func deselectItem() {
        if let selectedIndexPath = selectedIndexPath {
            mealsView.collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
    
    fileprivate func applySnapshot(with meals: [Meal], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Meal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(meals)
        self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    fileprivate func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Meal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.mealList)
        self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension MealsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var mealList: [Meal]
        if let searchText = self.navigationItem.searchController?.searchBar.text, !searchText.isEmpty {
            mealList = self.mealList.filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
        } else {
            mealList = self.mealList
        }
        
        let vc = RecipeViewController(meal: mealList[indexPath.item])
        vc.view.backgroundColor = .systemGroupedBackground
        self.navigationController?.pushViewController(vc, animated: true)
        selectedIndexPath = indexPath
    }
}

extension MealsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return self.applySnapshot()
        }
        
        let filtered = self.mealList.filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
        self.applySnapshot(with: filtered)
    }
}

extension MealsViewController {
    enum Section {
        case main
    }
}




