//
//  ApiVersion1.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 04.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

class ApiVersion1 {
    
    enum ErrorMessage {
        static let recipeNameIsRequired = "Field name is mandatory in body"
        static let recipeNameMustContainAckee = "Name must obtain Ackee at least once! This is Ackee cookbook GOD DAMN IT."
        static let recipeInfoIsRequired = "Field info is mandatory in body"
        static let recipeDescriptionIsRequired = "Field description is mandatory in body"
    }
    
    private let scheme: String
    private let host: String
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    func getRecipesHttpExchange(portion: Portion) -> GetRecipesApiVersion1HttpExchange {
        let httpExchange = GetRecipesApiVersion1HttpExchange(scheme: scheme, host: host, portion: portion)
        return httpExchange
    }
    
    func createNewRecipeHttpExchange(creatingRecipe: CreatingRecipe) -> CreateNewRecipeApiVersion1HttpExchange {
        let httpExchange = CreateNewRecipeApiVersion1HttpExchange(scheme: scheme, host: host, creatingRecipe: creatingRecipe)
        return httpExchange
    }
    
    func getRecipeHttpExchange(recipeId: String) -> GetRecipeApiVersion1HttpExchange {
        let httpExchange = GetRecipeApiVersion1HttpExchange(scheme: scheme, host: host, recipeId: recipeId)
        return httpExchange
    }
    
    func updateRecipeHttpExchange(updatingRecipe: UpdatingRecipe) -> UpdateRecipeApiVersion1HttpExchange {
        let httpExchange = UpdateRecipeApiVersion1HttpExchange(scheme: scheme, host: host, updatingRecipe: updatingRecipe)
        return httpExchange
    }
    
    func deleteRecipeHttpExchange(recipeId: String) -> DeleteRecipeApiVersion1HttpExchange {
        let httpExchange = DeleteRecipeApiVersion1HttpExchange(scheme: scheme, host: host, recipeId: recipeId)
        return httpExchange
    }
    
    func addNewRatingHttpExchange(addingRating: AddingRating) -> AddNewRatingApiVersion1HttpExchange {
        let httpExchange = AddNewRatingApiVersion1HttpExchange(scheme: scheme, host: host, addingRating: addingRating)
        return httpExchange
    }
    
}
