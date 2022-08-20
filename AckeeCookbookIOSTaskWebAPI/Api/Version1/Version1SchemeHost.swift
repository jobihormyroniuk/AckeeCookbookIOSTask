//
//  Version.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 04.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AFoundation
import AckeeCookbookIOSTaskBusiness

class WebApiVersion1SchemeHost: WebApiVersion1 {
        
    private let scheme: String
    private let host: String
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    // MARK: Get recipes
    
    func getRecipesRequest(limit: UInt = 10, offset: UInt = 0) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/api/v1/recipes"
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
        let queryItems = [offsetQueryItem, limitQueryItem]
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        return request
    }
    
    func getRecipesResponse(response: URLResponse, data: Data) -> GetRecipesResponse {
        do {
            let array = try JSONSerialization.objectsArray(with: data, options: [])
            var recipes: [RecipeInList] = []
            for object in array {
                let id = try object.stringForKey("id")
                let name = try object.stringForKey("name")
                let duration = try object.numberForKey("duration").uintValue
                let score = try object.numberForKey("score").floatValue
                let recipe = StructureRecipeInList(id: id, name: name, duration: duration, score: score)
                recipes.append(recipe)
             }
            return .recipes(recipes)
        } catch {
            return .error(error)
        }
    }
    
    // MARK: Create new recipe
    
    func createNewRecipeRequest(name: String, description: String, ingredients: [String]?, duration: UInt?, info: String?) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/api/v1/recipes"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var bodyJson: [String: Any] = [:]
        bodyJson["name"] = name
        bodyJson["description"] = description
        bodyJson["ingredients"] = ingredients
        bodyJson["duration"] = duration
        bodyJson["info"] = info
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        let body = try! JSONSerialization.data(withJSONObject: bodyJson, options: [])
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func createNewRecipeResponse(response: URLResponse, data: Data) -> CreateNewRecipeResponse {
        do {
            let object = try JSONSerialization.object(with: data, options: [])
            let recipe = try recipeInDetails(jsonObject: object)
            return .recipe(recipe)
        } catch {
            return .error(error)
        }
    }
    
    // MARK: Get recipe
    
    func getRecipeRequest(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/api/v1/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getRecipeResponse(response: URLResponse, data: Data) -> GetRecipeResponse {
        do {
            let object = try JSONSerialization.object(with: data, options: [])
            let recipe = try recipeInDetails(jsonObject: object)
            return .recipe(recipe)
        } catch {
            return .error(error)
        }
    }
    
    // MARK: Update recipe
    
    func updateRecipeRequest(id: String, name: String? = nil, description: String? = nil, ingredients: [String]? = nil, duration: UInt?, info: String? = nil) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let recipeId = id
        urlComponents.path = "/api/v1/recipes/\(recipeId)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        var bodyJSON: [String: Any] = [:]
        bodyJSON["name"] = name
        bodyJSON["description"] = description
        bodyJSON["ingredients"] = ingredients
        bodyJSON["duration"] = duration
        bodyJSON["info"] = info
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func updateRecipeResponse(response: URLResponse, data: Data) -> UpdateRecipeResponse {
        do {
            let object = try JSONSerialization.object(with: data, options: [])
            let recipe = try recipeInDetails(jsonObject: object)
            return .recipe(recipe)
        } catch {
            return .error(error)
        }
    }
    
    // MARK: Delete recipe
    
    func deleteRecipeRequest(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/api/v1/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }
    
    func deleteRecipeResponse(response: URLResponse, data: Data) -> DeleteRecipeResponse {
        if (response as? HTTPURLResponse)?.statusCode == 204 {
            return .deleted
        } else {
            let error = UnknownError()
            return .error(error)
        }
    }
    
    // MARK: Add new rating
    
    func addNewRatingRequest(id: String, score: Float) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = "/api/v1/recipes/\(id)/ratings"
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var bodyJSON: [String: Any] = [:]
        bodyJSON["score"] = score
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func addNewRatingResponse(response: URLResponse, data: Data) -> AddNewRatingResponse {
        do {
            let object = try JSONSerialization.object(with: data, options: [])
            let score = try object.numberForKey("score").floatValue
            return .score(score)
        } catch {
            return .error(error)
        }
    }
    
    /// MARK: Parsing
    
    private func recipeInDetails(jsonObject: JsonObject) throws -> RecipeInDetails {
        let id = try jsonObject.stringForKey("id")
        let name = try jsonObject.stringForKey("name")
        let description = try jsonObject.stringForKey("description")
        let info = try jsonObject.stringForKey("info")
        let ingredients = try jsonObject.stringsArrayForKey("ingredients")
        let duration = try jsonObject.numberForKey("duration").uintValue
        let score = try jsonObject.numberForKey("score").floatValue
        let recipe = RecipeInDetailsStructure(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
        return recipe
    }
}
