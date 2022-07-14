//
//  MealsViewController.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit

class MealsViewController: UIViewController {
    
    var meals: [Meal] = .init()
    var filteredMeals: [Meal] = .init()
    
    private let catgory: String
    private let mainView = MealsView()
    private var selectedIndexPath: IndexPath?
    private var searchBar = UISearchBar(frame: .zero)
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Meal>?
    private var network: NetworkProtocol
    
    init(
        category: String,
        network: NetworkProtocol = DefaultNetworkService.shared
    ) {
        self.catgory = category
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deselectItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        getMeals()
    }
    
    fileprivate func getMeals() {
        let mealRequest = MealsRequest(apiKey: "1", category: self.catgory)
        Task {
            let meals = try await network.request(mealRequest).meals?.sorted { $0.strMeal < $1.strMeal }
            await MainActor.run {
                self.meals = meals ?? .init()
                self.applySnapshot(with: self.meals)
            }
        }
    }
    
    fileprivate func setupSearchBar() {
        self.navigationItem.searchController = UISearchController()
        self.navigationItem.searchController?.searchResultsUpdater = self
        self.navigationItem.searchController?.searchBar.delegate = self
        self.navigationItem.searchController?.searchBar.placeholder = "Search name or id"
    }
    
    fileprivate func setupCollectionView() {
        self.title = catgory
        self.mainView.collectionView.delegate = self
        
        let registration = UICollectionView.CellRegistration<MealsViewItem, Meal> { cell, indexPath, meal in
            let content = cell.configure(with: meal)
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Meal>(collectionView: mainView.collectionView) {
            cv, indexPath, meal in
            return cv.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: meal)
        }
    }
    
    fileprivate func deselectItem() {
        if let selectedIndexPath = selectedIndexPath {
            mainView.collectionView.deselectItem(at: selectedIndexPath, animated: true)
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
        snapshot.appendItems(self.meals)
        self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension MealsViewController: UICollectionViewDelegate, UISearchBarDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var mealList: [Meal]
        if let searchText = self.navigationItem.searchController?.searchBar.text, !searchText.isEmpty {
            mealList = self.filteredMeals
        } else {
            mealList = self.meals
        }
        
        let vc = RecipeViewController(meal: mealList[indexPath.item])
        self.navigationController?.pushViewController(vc, animated: true)
        selectedIndexPath = indexPath
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredMeals = .init()
    }
}

extension MealsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            self.filteredMeals = .init()
            return self.applySnapshot()
        }
        
        self.filteredMeals = self.meals.filter {
            $0.strMeal.localizedCaseInsensitiveContains(searchText) || $0.idMeal.contains(searchText)
        }
        self.applySnapshot(with: self.filteredMeals)
    }
}

extension MealsViewController {
    enum Section {
        case main
    }
}




