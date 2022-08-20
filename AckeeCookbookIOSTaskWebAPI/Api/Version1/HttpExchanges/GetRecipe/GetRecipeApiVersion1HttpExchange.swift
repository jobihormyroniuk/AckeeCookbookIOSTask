//
//  ApiVersion1EndpointGetRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class GetRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<RecipeInDetails> {
    
    private let recipeId: String
    
    init(scheme: String, host: String, recipeId: String) {
        self.recipeId = recipeId
        super.init(scheme: scheme, host: host)
    }
    
    override func constructRequest() throws -> HttpRequest {
        let method = HttpRequestMethod.get
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(basePath)/recipes/\(recipeId)"
        let url = try urlComponents.url()
        let httpRequest = HttpRequest(method: method, uri: url, version: HttpVersion.http1dot1, headers: nil, body: nil)
        return httpRequest
    }
    
    override func parseResponse(_ httpResponse: HttpResponse) throws -> RecipeInDetails {
        let code = httpResponse.code
        guard code == HttpResponseCode.ok else {
            let error = MessageError("")
            throw error
        }
        let body = httpResponse.body ?? Data()
        let jsonObject = try JsonSerialization.jsonValue(body).object()
        let recipe = try recipeInDetails(jsonObject: jsonObject)
        return recipe
    }
    
}

