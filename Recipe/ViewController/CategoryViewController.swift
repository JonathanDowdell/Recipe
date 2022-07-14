//
//  CategoryViewController.swift
//  Recipe
//
//  Created by Mettaworldj on 7/13/22.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var categories = [Category]()
    var meals = [Meal]()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let network: NetworkProtocol
    
    private let mainView = CategoryView()
    private var searchBar = UISearchBar(frame: .zero)
    private var selectedIndexPath: IndexPath?
    
    private var filteredCategories = [Category]()
    
    typealias SectionData = (section: Section, data: [AnyHashable])
    
    init(network: NetworkProtocol = DefaultNetworkService.shared) {
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
        getCategories()
    }
    
    fileprivate func deselectItem() {
        if let selectedIndexPath = selectedIndexPath {
            mainView.collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
    
    fileprivate func getCategories() {
        Task {
            let categoryWrapper = try await network.request(CategoryRequest(apiKey: "1"))
            await MainActor.run {
                self.categories = categoryWrapper.categories
                self.applySnapshot()
            }
        }
    }
    
    fileprivate func setupSearchBar() {
        self.navigationItem.searchController = UISearchController()
        self.navigationItem.searchController?.searchResultsUpdater = self
        self.navigationItem.searchController?.searchBar.delegate = self
    }
    
    fileprivate func setupCollectionView() {
        self.title = "Recipes"
        self.mainView.collectionView.delegate = self
        
        let categoryRegistration = UICollectionView.CellRegistration<CategoryItem, Category> { cell, indexPath, category in
            let content = cell.configure(with: category)
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        let categoryHeaderRegistration = UICollectionView.SupplementaryRegistration<RecipeSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, string, indexPath in
            supplementaryView.titleLabel.text = "Categories"
        }
        
        let mealRegisteration = UICollectionView.CellRegistration<MealsViewItem, Meal> { cell, indexPath, meal in
            let content = cell.configure(with: meal)
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        let mealHeaderRegistration = UICollectionView.SupplementaryRegistration<RecipeSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, string, indexPath in
            supplementaryView.titleLabel.text = "Meals"
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: mainView.collectionView) {
            cv, indexPath, item in
            
            switch Section(rawValue: indexPath.section) {
            case .category:
                return cv.dequeueConfiguredReusableCell(using: categoryRegistration, for: indexPath, item: item as? Category)
            case .meal:
                return cv.dequeueConfiguredReusableCell(using: mealRegisteration, for: indexPath, item: item as? Meal)
            }
        }
        
        dataSource?.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            switch Section(rawValue: indexPath.section) {
            case .category:
                return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: categoryHeaderRegistration, for: indexPath)
            case .meal:
                return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: mealHeaderRegistration, for: indexPath)
            }
        }
    }
    
    fileprivate func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.category])
        snapshot.appendItems(categories, toSection: .category)
        self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    fileprivate func applySnapshot(with data: [AnyHashable]? = nil, to section: Section, animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([section])
        if let data = data {
            snapshot.appendItems(data, toSection: section)
        } else {
            snapshot.appendItems(categories, toSection: section)
        }
        self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    fileprivate func applySnapshot(with data: [SectionData], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(data.map { $0.section })
        for datum in data {
            let section = datum.section
            let sectionData = datum.data
            snapshot.appendItems(sectionData, toSection: section)
        }
        self.dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            self.meals = .init()
            return self.applySnapshot()
        }
        
        let mealSearchRequest = MealSearchRequest(apiKey: "1", queryItems: ["s":searchText])
        
        Task {
            let mealSearchResults = try await network.request(mealSearchRequest)
            self.meals = mealSearchResults.meals ?? .init()
            var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snapshot.appendSections([.category, .meal])
            snapshot.appendItems(self.filteredCategories, toSection: .category)
            snapshot.appendItems(self.meals, toSection: .meal)
            await MainActor.run {
                self.dataSource?.apply(snapshot, animatingDifferences: true)
            }
        }
    }
}

extension CategoryViewController {
    enum Section: Int, CaseIterable {
        case category
        case meal
        
        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .category
            case 1: self = .meal
            default: self = .category
            }
        }
    }
}

extension CategoryViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            self.meals = .init()
            return self.applySnapshot()
        }

        filteredCategories = categories.filter { $0.strCategory.localizedCaseInsensitiveContains(searchText) }
        let sectionData: SectionData = (section: Section.category, data: filteredCategories)
        self.applySnapshot(with: [sectionData])

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: searchController.searchBar)
        self.perform(#selector(self.reload(_:)), with: searchController.searchBar, afterDelay: 0.9)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("Restore")
//        self.applySnapshot()
    }
}

struct RandomObject {
    let filteredCategories: [Category]
    let searchString: String
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        switch Section(rawValue: indexPath.section) {
        case .category:
            self.navigationController?.pushViewController(MealsViewController(category: categories[indexPath.item].strCategory), animated: true)
        case .meal:
            self.navigationController?.pushViewController(RecipeViewController(meal: meals[indexPath.item]), animated: true)
        }
    }
}
