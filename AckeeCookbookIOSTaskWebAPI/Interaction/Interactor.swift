//
//  WebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public protocol Interactor {
    
    func getRecipes(portion: Portion, completionHandler: @escaping (Result<[RecipeInList], InteractionError>) -> ())
    func createNewRecipe(creatingRecipe: CreatingRecipe, completionHandler: @escaping (Result<CreateNewRecipeResult, InteractionError>) -> ())
    func getRecipe(recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, InteractionError>) -> ())
    func updateRecipe(updatingRecipe: UpdatingRecipe, completionHandler: @escaping (Result<UpdateRecipeResult, InteractionError>) -> ())
    func deleteRecipe(recipeId: String, completionHandler: @escaping (InteractionError?) -> ())
    func addNewRating(addingRating: AddingRating, completionHandler: @escaping (Result<AddedRating, InteractionError>) -> ())
    
}
