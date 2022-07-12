//
//  NetworkProtocol.swift
//  Recipe
//
//  Created by Mettaworldj on 7/12/22.
//

import Foundation

protocol NetworkProtocol {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}
