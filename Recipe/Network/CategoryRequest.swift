//
//  CategoryRequest.swift
//  Recipe
//
//  Created by Mettaworldj on 7/13/22.
//

import Foundation

struct CategoryRequest: DataRequest {
    
    var apiKey: String
    
    var url: String {
        let baseURL: String = "https://www.themealdb.com/api/json/v1"
        let path: String = "/\(apiKey)/categories.php"
        return baseURL + path
    }
    
    var method: HTTPMethod = .get
    
    var headers: [String : String] = .init()
    
    var decoder: JSONDecoder = .init()
    
    var encoder: JSONEncoder = .init()
    
    typealias Response = CategoryWrapper
    
    
}
