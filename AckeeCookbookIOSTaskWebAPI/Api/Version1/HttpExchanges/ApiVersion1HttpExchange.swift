//
//  ApiVersion1Endpoint.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class ApiVersion1HttpExchange<ParsedHttpResponse>: SchemeHostHttpExchange<ParsedHttpResponse> {
    
    let basePath: String = "/api/v1"
    
    func recipeInDetails(jsonObject: JsonObject) throws -> RecipeInDetails {
        let id = try jsonObject.string("id")
        let name = try jsonObject.string("name")
        let description = try jsonObject.string("description")
        let info = try jsonObject.string("info")
        let ingredients = try jsonObject.array("ingredients").strings()
        let duration = try jsonObject.number("duration").int()
        let score = try jsonObject.number("score").float()
        let recipe = RecipeInDetails(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
        return recipe
    }
    
}
