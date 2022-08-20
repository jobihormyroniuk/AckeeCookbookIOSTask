//
//  ApiVersion1GetRecipes.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class GetRecipesApiVersion1HttpExchange: ApiVersion1HttpExchange<[RecipeInList]> {
    
    private let portion: Portion
    
    init(scheme: String, host: String, portion: Portion) {
        self.portion = portion
        super.init(scheme: scheme, host: host)
    }

    override func constructRequest() throws -> HttpRequest {
        let method = HttpRequestMethod.get
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(basePath)/recipes"
        var urlQueryItems: [URLQueryItem] = []
        urlQueryItems.append(URLQueryItem(name: "offset", value: "\(portion.offset)"))
        urlQueryItems.append(URLQueryItem(name: "limit", value: "\(portion.limit)"))
        urlComponents.queryItems = urlQueryItems
        let url = try urlComponents.url()
        let version = HttpVersion.http1dot1
        let httpRequest = HttpRequest(method: method, uri: url, version: version, headers: nil, body: nil)
        return httpRequest
    }

    override func parseResponse(_ httpResponse: HttpResponse) throws -> [RecipeInList] {
        let code = httpResponse.code
        guard code == HttpResponseCode.ok else {
            let error = MessageError("")
            throw error
        }
        let body = httpResponse.body ?? Data()
        let jsonArray = try JsonSerialization.jsonValue(body).array().objects()
        var recipes: [RecipeInList] = []
        for jsonObject in jsonArray {
            let id = try jsonObject.string("id")
            let name = try jsonObject.string("name")
            let duration = try jsonObject.number("duration").int()
            let score = try jsonObject.number("score").float()
            let recipe = RecipeInList(id: id, name: name, duration: duration, score: score)
            recipes.append(recipe)
        }
        return recipes
    }

    
}
