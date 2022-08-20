//
//  ApiVersion1EndpointAddNewRating.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class AddNewRatingApiVersion1HttpExchange: ApiVersion1HttpExchange<AddedRating> {
    
    private let addingRating: AddingRating
    
    init(scheme: String, host: String, addingRating: AddingRating) {
        self.addingRating = addingRating
        super.init(scheme: scheme, host: host)
    }
    
    override func constructRequest() throws -> HttpRequest {
        let method = HttpRequestMethod.post
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(basePath)/recipes/\(addingRating.recipeId)/ratings"
        let url = try urlComponents.url()
        var headers: [String: String] = [:]
        headers[HttpHeaderField.contentType] = MediaType.json
        var jsonValue: JsonObject = JsonObject()
        jsonValue.setNumber(Decimal(addingRating.score), for: "score")
        let body = try JsonSerialization.data(jsonValue)
        let httpRequest = HttpRequest(method: method, uri: url, version: HttpVersion.http1dot1, headers: headers, body: body)
        return httpRequest
    }
    
    override func parseResponse(_ httpResponse: HttpResponse) throws -> AddedRating {
        let code = httpResponse.code
        guard code == HttpResponseCode.ok else {
            let error = MessageError("")
            throw error
        }
        let body = httpResponse.body ?? Data()
        let jsonObject = try JsonSerialization.jsonValue(body).object()
        let id = try jsonObject.string("id")
        let recipeId = try jsonObject.string("recipe")
        let score = try jsonObject.number("score").float()
        let addedNewRating = AddedRating(id: id, recipeId: recipeId, score: score)
        return addedNewRating
    }
    
}
