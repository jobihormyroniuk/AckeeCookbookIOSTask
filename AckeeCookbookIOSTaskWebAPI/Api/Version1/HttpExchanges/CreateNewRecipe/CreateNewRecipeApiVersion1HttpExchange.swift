//
//  ApiVersion1EndpointCreateNewRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AFoundation

class CreateNewRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<CreateNewRecipeResult> {
    
    private let creatingRecipe: CreatingRecipe
    
    init(scheme: String, host: String, creatingRecipe: CreatingRecipe) {
        self.creatingRecipe = creatingRecipe
        super.init(scheme: scheme, host: host)
    }
    
    override func constructRequest() throws -> HttpRequest {
        let method = HttpRequestMethod.post
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(basePath)/recipes"
        let url = try urlComponents.url()
        var headers: [String: String] = [:]
        headers[HttpHeaderField.contentType] = MediaType.json
        var jsonValue: JsonObject = JsonObject()
        jsonValue.setString(creatingRecipe.name, for: "name")
        jsonValue.setString(creatingRecipe.description, for: "description")
        jsonValue.setArray(JsonArray(creatingRecipe.ingredients), for: "ingredients")
        jsonValue.setNumber(Decimal(creatingRecipe.duration), for: "duration")
        jsonValue.setString(creatingRecipe.info, for: "info")
        let body = try JsonSerialization.data(jsonValue)
        let httpRequest = HttpRequest(method: method, uri: url, version: HttpVersion.http1dot1, headers: headers, body: body)
        return httpRequest
    }
    
    override func parseResponse(_ httpResponse: HttpResponse) throws -> CreateNewRecipeResult {
        let code = httpResponse.code
        let body = httpResponse.body ?? Data()
        let jsonObject = try JsonSerialization.jsonValue(body).object()
        if code == HttpResponseCode.ok {
            let recipe = try recipeInDetails(jsonObject: jsonObject)
            return .createdNewRecipe(recipe)
        } else if code == HttpResponseCode.badRequest {
            let message = try jsonObject.string("message")
            if message == ApiVersion1.ErrorMessage.recipeInfoIsRequired {
                return .infoIsRequired
            } else if message == ApiVersion1.ErrorMessage.recipeDescriptionIsRequired {
                return .descriptionIsRequired
            } else if message == ApiVersion1.ErrorMessage.recipeNameMustContainAckee {
                return .nameMustContainAckee
            } else if message == ApiVersion1.ErrorMessage.recipeNameIsRequired {
                return .nameIsRequired
            } else {
                let error = MessageError("")
                throw error
            }
        } else {
            let error = MessageError("")
            throw error
        }
    }
    
}
