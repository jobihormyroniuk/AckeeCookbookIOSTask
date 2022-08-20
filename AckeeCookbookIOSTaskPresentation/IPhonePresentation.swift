//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

public protocol IPhonePresentationDelegate: AnyObject {
    func iPhonePresentationGetRecipes(_ iPhonePresentation: IPhonePresentation, offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ())
    func iPhonePresentationCreateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: AddingRecipe, completionHandler: @escaping (Result<AddRecipeResult, Error>) -> ())
    func iPhonePresentationGetRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func iPhonePresentationDeleteRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInDetails, completionHandler: @escaping (Error?) -> ())
    func iPhonePresentationScoreRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInDetails, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ())
    func iPhonePresentationUpdateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: UpdatingRecipe, completionHandler: @escaping (Result<UpdateRecipeResult, Error>) -> ())
}

public class IPhonePresentation: AUIWindowPresentation, RecipesListScreenDelegate, AddRecipeScreenControllerDelegate, RecipesDetailsScreenControllerDelegate, UpdateRecipeScreenDelegate {

    // MARK: Setup
    
    public override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
    }
    
    // MARK: Keyboard
    
    @objc private func keyboardWillChangeFrame(notification: NSNotification) {
        guard let height = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]) as? NSValue)?.cgRectValue.origin.y else { return }
        guard let view = mainNavigationController?.viewControllers.last?.view else { return }
        view.frame.size.height = height
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    // MARK: Presentation
    
    public func showRecipesList() {
        let navigationController = AUINavigationController()
        let screenView = RecipesListScreenView()
        let screenController = RecipesListScreenController(view: screenView)
        screenController.delegate = self
        navigationController.viewControllers = [screenController]
        self.mainNavigationController = navigationController
        self.recipesListScreen = screenController
        self.window.rootViewController = navigationController
    }

    public weak var delegate: IPhonePresentationDelegate?

    // MARK: Main Navigation Controller

    private weak var mainNavigationController: UINavigationController?

    // MARK: Recipes List Screen

    private weak var recipesListScreen: RecipesListScreenController?

    func recipesListScreenAddRecipe(_ recipesListScreen: RecipesListScreenController) {
        let screenView = AddRecipeScreenView()
        let screenController = AddRecipeScreenController(view: screenView)
        screenController.delegate = self
        addRecipeScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }

    func recipesListScreenGetRecipes(_ recipesListScreen: RecipesListScreenController, offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ()) {
        delegate?.iPhonePresentationGetRecipes(self, offset: offset, limit: limit, completionHandler: { (result) in
            DispatchQueue.main.async {
                switch result {
                case let .success(recipesInList): break
                case let .failure(error):
                    let items = [String(reflecting: error)]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    recipesListScreen.present(ac, animated: true)
                }
                completionHandler(result)
            }
        })
    }

    func recipesListScreenShowRecipeDetails(_ recipesListScreen: RecipesListScreenController, recipeInList: RecipeInList) {
        let screenView = RecipeDetailsScreenView()
        let screenController = RecipeDetailsScreenController(view: screenView, recipeInList: recipeInList)
        screenController.delegate = self
        recipeInDetailsScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }

    // MARK: Add Recipe Screen

    private weak var addRecipeScreen: AddRecipeScreenController?

    func addRecipeScreenBack(_ addRecipeScreen: AddRecipeScreenController) {
        mainNavigationController?.popViewController(animated: true)
    }

    func addRecipeScreenAddRecipe(_ addRecipeScreen: AddRecipeScreenController, _ recipe: AddingRecipe) {
        delegate?.iPhonePresentationCreateRecipe(self, recipe: recipe, completionHandler: { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    switch result {
                    case let .addedRecipe(recipe):
                        let recipeInList = RecipeInList(id: recipe.id, name: recipe.name, duration: recipe.duration, score: recipe.score)
                        self.recipesListScreen?.knowRecipeWasAdded(recipeInList)
                        self.mainNavigationController?.popViewController(animated: true)
                    case .infoIsRequired:
                        let alertController = self.createMessageAlertController("\"Info\" MUST be filled!")
                        self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                        break
                    case .descriptionIsRequired:
                        let alertController = self.createMessageAlertController("\"Description\" MUST be filled!")
                        self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                    case .nameMustContainAckee:
                        let alertController = self.createMessageAlertController("\"Name\" MUST contain \"ackee\" string!")
                        self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                    case .nameIsRequired:
                        let alertController = self.createMessageAlertController("\"Name\" MUST be filled!")
                        self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    let alertController = self.createInternalErrorAlertController(error)
                    self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }

    // MARK: Recipe In Details Screen

    private weak var recipeInDetailsScreen: RecipeDetailsScreenController?

    func recipeInDetailsScreenBack(_ recipeInDetailsScreen: RecipeDetailsScreenController) {
        mainNavigationController?.popViewController(animated: true)
    }
    
    func recipeInDetailsScreenGetRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInList: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        delegate?.iPhonePresentationGetRecipe(self, recipe: recipeInList, completionHandler: { (result) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        })
    }

    func recipeInDetailsScreenDeleteRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInDetails: RecipeInDetails) {
        let alertController = UIAlertController(title: nil, message: "Confirm deletion.", preferredStyle: .alert)
        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
            self.delegate?.iPhonePresentationDeleteRecipe(self, recipe: recipeInDetails, completionHandler: { (error) in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let recipeInList = RecipeInList(id: recipeInDetails.id, name: recipeInDetails.name, duration: recipeInDetails.duration, score: recipeInDetails.score)
                    self.recipesListScreen?.knowRecipeWasDeleted(recipeInList)
                    guard let recipesListScreen = self.recipesListScreen else { return }
                    self.mainNavigationController?.popToViewController(recipesListScreen, animated: true)
                }
            })
        }
        alertController.addAction(deleteAlertAction)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAlertAction)
        mainNavigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func recipeInDetailsScreenUpdateRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInDetails: RecipeInDetails) {
        let screenView = UpdateRecipeScreenView()
        let screenController = UpdateRecipeScreenController(view: screenView, recipe: recipeInDetails)
        screenController.delegate = self
        updateRecipeScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }
    
    func recipeInDetailsScreenSetScore(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipe: RecipeInDetails, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ()) {
        delegate?.iPhonePresentationScoreRecipe(self, recipe: recipe, score: score, completionHandler: { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let score):
                    completionHandler(result)
                    let recipeInList = RecipeInList(id: recipe.id, name: recipe.name, duration: recipe.duration, score: recipe.score)
                    self.recipesListScreen?.knowRecipeScoreWasChanged(recipeInList, score: score)
                case .failure(let error):
                    let alertController = self.createInternalErrorAlertController(error)
                    self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    // MARK: Update Recipe Screen

    private weak var updateRecipeScreen: UpdateRecipeScreenController?
    
    func updateRecipeScreenBack(_ updateRecipeScreen: UpdateRecipeScreenController) {
        mainNavigationController?.popViewController(animated: true)
    }
    
    func updateRecipeScreenUpdateRecipe(_ recipe: UpdatingRecipe) {
        delegate?.iPhonePresentationUpdateRecipe(self, recipe: recipe, completionHandler: { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    switch result {
                    case let .updatedRecipe(recipe):
                        self.recipeInDetailsScreen?.updateRecipe(recipe)
                        let recipeInList = RecipeInList(id: recipe.id, name: recipe.name, duration: recipe.duration, score: recipe.score)
                        self.recipesListScreen?.knowRecipeWasUpdated(recipeInList)
                        self.mainNavigationController?.popViewController(animated: true)
                    case .infoIsRequired:
                        let alertController = self.createMessageAlertController("\"Info\" MUST be filled!")
                        self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                        break
                    case .descriptionIsRequired:
                        let alertController = self.createMessageAlertController("\"Description\" MUST be filled!")
                        self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                    case .nameMustContainAckee:
                        let alertController = self.createMessageAlertController("\"Name\" MUST contain \"ackee\" string!")
                        self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                    case .nameIsRequired:
                        let alertController = self.createMessageAlertController("\"Name\" MUST be filled!")
                        self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    let alertController = self.createInternalErrorAlertController(error)
                    self.mainNavigationController?.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    // MARK: Error Alert
    
    private func createInternalErrorAlertController(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .destructive)
        alertController.addAction(okAlertAction)
        return alertController
    }
    
    private func createMessageAlertController(_ message: String) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .destructive)
        alertController.addAction(okAlertAction)
        return alertController
    }
    
}
