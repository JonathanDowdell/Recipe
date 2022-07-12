//
//  DataRequest.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import Foundation

protocol DataRequest {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [String : String] { get }
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    var header: [String: String] { [:] }
    
    var queryItems: [String: String] { [:] }
}
