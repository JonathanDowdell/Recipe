//
//  MealsRequest.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import Foundation

struct MealsRequest: DataRequest {
    
    var apiKey: String
    
    var url: String {
        let baseURL: String = "https://www.themealdb.com/api/json/v1"
        let path: String = "/\(apiKey)/filter.php"
        return baseURL + path
    }
    
    var method: HTTPMethod { return .get }
    
    var headers: [String : String] { return [:] }
    
    var category: String
    
    var queryItems: [String : String] { return ["c": category] }
    
    var decoder: JSONDecoder = .init()
    
    var encoder: JSONEncoder = .init()
    
    typealias Response = Meals
    
}
