//
//  RecipeViewController.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import UIKit

class RecipeViewController: UIViewController {
    
    private let recipeView = RecipeView()
    private let meal: Meal
    
    init(meal: Meal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = recipeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = meal.strMeal
        getRecipe()
    }
    
    func getRecipe() {
        let recipeRequest = RecipeRequest(apiKey: "1", recipeId: meal.idMeal)
        DefaultNetworkService().request(recipeRequest) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension RecipeViewController {
    enum Section {
        case header
        case main
        case footer
    }
}
