//
//  RecipeTests.swift
//  RecipeTests
//
//  Created by Mettaworldj on 7/12/22.
//

import XCTest
@testable import Recipe

extension RecipeTests {
    
    static let staticMeal = Meal(strMeal: "Battenberg Cake", strMealThumb: "https://www.themealdb.com/images/media/meals/ywwrsp1511720277.jpg", idMeal: "52894")
    
    static let staticRecipe = Recipe(idMeal: "52894", strMeal: "", strDrinkAlternate: "", strCategory: "", strArea: "", strInstructions: "", strMealThumb: "", strTags: "", strYoutube: "", strSource: "", strImageSource: "", strCreativeCommonsConfirmed: "", ingredients: .init())
    
    class MockNetwork: NetworkProtocol {
        func request<Request>(_ request: Request) async throws -> Request.Response where Request : DataRequest {
            if let _ = request as? MealsRequest {
                return MealsWrapper(meals: [staticMeal]) as! Request.Response
            } else if let _ = request as? RecipeRequest {
                return RecipeWrapper(meals: [staticRecipe], data: Data()) as! Request.Response
            }
            return MealsWrapper(meals: [staticMeal]) as! Request.Response
        }
        
        func request<Request>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) where Request : DataRequest {
            completion(.success(MealsWrapper(meals: [staticMeal]) as! Request.Response))
        }
    }
    
}

class RecipeTests: XCTestCase {
    
    func testMealsViewController() async {
        let mealViewController = await MealsViewController(network: MockNetwork())
        await mealViewController.viewDidLoad()
        let loadedMeals = await mealViewController.meals
        let mealsNotEmpty = !loadedMeals.isEmpty
        XCTAssert(mealsNotEmpty, "Has Content")
    }
    
    func testRecipeViewController() async {
        let recipeViewController = await RecipeViewController(meal: RecipeTests.staticMeal, network: MockNetwork())
        let innerId = await recipeViewController.meal.idMeal
        let outterId = RecipeTests.staticMeal.idMeal
        XCTAssertEqual(innerId, outterId, "Inner Id does not match Outter Id")
        
        await recipeViewController.viewDidLoad()
        let loadedRecipe = await recipeViewController.recipe
        XCTAssertNotNil(loadedRecipe, "RecipeViewController didn't load Recipe")
    }

}
