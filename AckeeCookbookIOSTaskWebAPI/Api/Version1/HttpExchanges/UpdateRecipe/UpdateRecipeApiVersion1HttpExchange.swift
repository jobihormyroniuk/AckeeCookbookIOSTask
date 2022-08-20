//
//  ApiVersion1EndpointUpdateRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class UpdateRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<UpdateRecipeResult> {
    
    private let updatingRecipe: UpdatingRecipe
    
    init(scheme: String, host: String, updatingRecipe: UpdatingRecipe) {
        self.updatingRecipe = updatingRecipe
        super.init(scheme: scheme, host: host)
    }
    
    override func constructRequest() throws -> HttpRequest {
        let method = HttpRequestMethod.put
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(basePath)/recipes/\(updatingRecipe.recipeId)"
        let url = try urlComponents.url()
        var headers: [String: String] = [:]
        headers[HttpHeaderField.contentType] = MediaType.json
        var jsonValue: JsonObject = JsonObject()
        jsonValue.setString(updatingRecipe.name, for: "name")
        jsonValue.setString(updatingRecipe.description, for: "description")
        jsonValue.setArray(JsonArray(updatingRecipe.ingredients), for: "ingredients")
        jsonValue.setNumber(Decimal(updatingRecipe.duration), for: "duration")
        jsonValue.setString(updatingRecipe.info, for: "info")
        let body = try JsonSerialization.data(jsonValue)
        let httpRequest = HttpRequest(method: method, uri: url, version: HttpVersion.http1dot1, headers: headers, body: body)
        return httpRequest
    }
    
    override func parseResponse(_ httpResponse: HttpResponse) throws -> UpdateRecipeResult {
        let code = httpResponse.code
        let body = httpResponse.body ?? Data()
        let jsonObject = try JsonSerialization.jsonValue(body).object()
        if code == HttpResponseCode.ok {
            let recipe = try recipeInDetails(jsonObject: jsonObject)
            return .updatedRecipe(recipe)
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
