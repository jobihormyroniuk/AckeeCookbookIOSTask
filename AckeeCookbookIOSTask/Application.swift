//
//  Application.swift
//  AckeeCookbookIOSTask
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskPresentation
typealias PresentationRecipeInList = AckeeCookbookIOSTaskPresentation.RecipeInList
typealias PresentationRecipeInDetails = AckeeCookbookIOSTaskPresentation.RecipeInDetails
typealias PresentationAddingRecipe = AckeeCookbookIOSTaskPresentation.AddingRecipe
typealias PresentationAddRecipeResult = AckeeCookbookIOSTaskPresentation.AddRecipeResult
typealias PresentationUpdatingRecipe = AckeeCookbookIOSTaskPresentation.UpdatingRecipe
typealias PresentationUpdateRecipeResult = AckeeCookbookIOSTaskPresentation.UpdateRecipeResult
import AckeeCookbookIOSTaskWebAPI
typealias WebApiCreatingRecipe = AckeeCookbookIOSTaskWebAPI.CreatingRecipe
typealias WebApiUpdatingRecipe = AckeeCookbookIOSTaskWebAPI.UpdatingRecipe

class Application: AUIEmptyApplication, IPhonePresentationDelegate {
    
    // MARK: Launching
    
    override func didFinishLaunching() {
        super.didFinishLaunching()
        presentationWindow.makeKeyAndVisible()
        iPhonePresentation.showRecipesList()
    }

    // MARK: Presentation
    
    private lazy var presentationWindow: UIWindow = {
        return window ?? UIWindow()
    }()
    
    private lazy var iPhonePresentation: IPhonePresentation = {
        let iPhonePresentation = IPhonePresentation(window: presentationWindow)
        iPhonePresentation.delegate = self
        return iPhonePresentation
    }()

    func iPhonePresentationGetRecipes(_ iPhonePresentation: IPhonePresentation, offset: Int, limit: Int, completionHandler: @escaping (Result<[PresentationRecipeInList], Error>) -> ()) {
        let portion = Portion(limit: limit, offset: offset)
        apiInteractor.getRecipes(portion: portion) { (result) in
            let presentationResult: Result<[PresentationRecipeInList], Error>
            switch result {
            case .success(let recipes):
                let presentationRecipesInList = recipes.map({ PresentationRecipeInList(id: $0.id, name: $0.name, duration: $0.duration, score: $0.score) })
                presentationResult = .success(presentationRecipesInList)
            case .failure(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }

    func iPhonePresentationCreateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: PresentationAddingRecipe, completionHandler: @escaping (Result<PresentationAddRecipeResult, Error>) -> ()) {
        let webApiCreatingRecipe = WebApiCreatingRecipe(name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        apiInteractor.createNewRecipe(creatingRecipe: webApiCreatingRecipe) { (result) in
            let presentationResult: Result<PresentationAddRecipeResult, Error>
            switch result {
            case .success(let result):
                switch result {
                case let .createdNewRecipe(recipe):
                    let presentationRecipeInDetails = PresentationRecipeInDetails(id: recipe.id, name: recipe.name, duration: recipe.duration, description: recipe.description, info: recipe.info, ingredients: recipe.ingredients, score: recipe.score)
                    presentationResult = .success(.addedRecipe(presentationRecipeInDetails))
                case .infoIsRequired:
                    presentationResult = .success(.infoIsRequired)
                case .descriptionIsRequired:
                    presentationResult = .success(.descriptionIsRequired)
                case .nameMustContainAckee:
                    presentationResult = .success(.nameMustContainAckee)
                case .nameIsRequired:
                    presentationResult = .success(.nameIsRequired)
                }
            case .failure(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }
    
    func iPhonePresentationGetRecipe(_ iPhonePresentation: IPhonePresentation, recipe: PresentationRecipeInList, completionHandler: @escaping (Result<PresentationRecipeInDetails, Error>) -> ()) {
        apiInteractor.getRecipe(recipeId: recipe.id) { (result) in
            let presentationResult: Result<PresentationRecipeInDetails, Error>
            switch result {
            case .success(let recipe):
                let presentationRecipeInDetails = PresentationRecipeInDetails(id: recipe.id, name: recipe.name, duration: recipe.duration, description: recipe.description, info: recipe.info, ingredients: recipe.ingredients, score: recipe.score)
                presentationResult = .success(presentationRecipeInDetails)
            case .failure(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }
    
    func iPhonePresentationDeleteRecipe(_ iPhonePresentation: IPhonePresentation, recipe: PresentationRecipeInDetails, completionHandler: @escaping (Error?) -> ()) {
        apiInteractor.deleteRecipe(recipeId: recipe.id) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func iPhonePresentationScoreRecipe(_ iPhonePresentation: IPhonePresentation, recipe: PresentationRecipeInDetails, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ()) {
        let addingRating = AddingRating(recipeId: recipe.id, score: score)
        apiInteractor.addNewRating(addingRating: addingRating) { (result) in
            let presentationResult: Result<Float, Error>
            switch result {
            case let .success(addedNewRating):
                let score = addedNewRating.score
                presentationResult = .success(score)
            case let .failure(error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }
    
    func iPhonePresentationUpdateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: PresentationUpdatingRecipe, completionHandler: @escaping (Result<PresentationUpdateRecipeResult, Error>) -> ()) {
        let webApiUpdatingRecipe = WebApiUpdatingRecipe(recipeId: recipe.id, name: recipe.name, duration: recipe.duration, description: recipe.description, info: recipe.info, ingredients: recipe.ingredients)
        apiInteractor.updateRecipe(updatingRecipe: webApiUpdatingRecipe) { (result) in
            let presentationResult: Result<PresentationUpdateRecipeResult, Error>
            switch result {
            case .success(let result):
                switch result {
                case let .updatedRecipe(recipe):
                    let presentationRecipeInDetails = PresentationRecipeInDetails(id: recipe.id, name: recipe.name, duration: recipe.duration, description: recipe.description, info: recipe.info, ingredients: recipe.ingredients, score: recipe.score)
                    presentationResult = .success(.updatedRecipe(presentationRecipeInDetails))
                case .infoIsRequired:
                    presentationResult = .success(.infoIsRequired)
                case .descriptionIsRequired:
                    presentationResult = .success(.descriptionIsRequired)
                case .nameMustContainAckee:
                    presentationResult = .success(.nameMustContainAckee)
                case .nameIsRequired:
                    presentationResult = .success(.nameIsRequired)
                }
            case .failure(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }

    // MARK: WebAPI

    private lazy var apiInteractor: Interactor = {
        let apiInteractor = Interactors.mockServer
        return apiInteractor
    }()
    
}
