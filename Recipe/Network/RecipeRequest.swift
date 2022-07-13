//
//  RecipeRequest.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import Foundation

struct RecipeRequest: DataRequest {
    typealias Response = RecipeWrapper
    
    var apiKey: String
    
    var url: String {
        let baseURL: String = "https://www.themealdb.com/api/json/v1"
        let path: String = "/\(apiKey)/lookup.php"
        return baseURL + path
    }
    
    var method: HTTPMethod { return .get }
    
    var headers: [String : String] { return [:] }
    
    var recipeId: String
    
    var queryItems: [String : String] { return ["i": recipeId] }
    
    var decoder: JSONDecoder = .init()
    
    var encoder: JSONEncoder = .init()
    
    func decode(_ data: Data) throws -> RecipeWrapper {
        var recipeWrapper = try decoder.decode(RecipeWrapper.self, from: data)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? .init()
        if let recipeArray = json["meals"] as? [[String: Any]], let recipe = recipeArray.first {
            recipeWrapper.meals?[0].ingredients = getIngredients(from: recipe)
        }
        return recipeWrapper
    }
    
    private func getIngredients(from dictionary: [String: Any]) -> [Ingredient]? {
        var ingredients = [Ingredient]()
        var keepGoing = true
        var index = 1
        repeat {
            let ingredient = dictionary["strIngredient\(index)"] as? String
            let measurement = dictionary["strMeasure\(index)"] as? String
            
            if let ingredient = ingredient, let measurement = measurement, !ingredient.isEmpty && !measurement.isEmpty {
                ingredients.append(Ingredient(ingredient: ingredient, measurement: measurement))
            } else {
                keepGoing = false
            }
            
            index += 1
        } while (keepGoing)
        return Set(ingredients).map { $0 }.sorted { $0.ingredient < $1.measurement }
    }
}
