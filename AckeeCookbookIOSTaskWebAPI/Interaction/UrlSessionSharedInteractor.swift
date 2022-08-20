//
//  URLSessionSharedWebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class UrlSessionSharedInteractor: Interactor {
    
    private let scheme: String
    private let host: String
    private let session = URLSession.shared
    private let api: Api
    
    public init(version1Scheme: String, version1Host: String) {
        self.scheme = version1Scheme
        self.host = version1Host
        let api = Api(scheme: scheme, host: host)
        self.api = api
    }
    
    public func getRecipes(portion: Portion, completionHandler: @escaping (Result<[RecipeInList], InteractionError>) -> ()) {
        let httpExchange = api.version1.getRecipesHttpExchange(portion: portion)
        do {
            let dataTask = try session.httpExchangeDataTask(httpExchange) { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .parsedResponse(let recipes):
                        completionHandler(.success(recipes))
                    case .notConnectedToInternet:
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    case .networkConnectionLost(_):
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    }
                case .failure(let error):
                    let interactionError = InteractionError(error: error)
                    completionHandler(.failure(interactionError))
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
    }
    
    public func createNewRecipe(creatingRecipe: CreatingRecipe, completionHandler: @escaping (Result<CreateNewRecipeResult, InteractionError>) -> ()) {
        let httpExchange = api.version1.createNewRecipeHttpExchange(creatingRecipe: creatingRecipe)
        do {
            let dataTask = try session.httpExchangeDataTask(httpExchange) { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .parsedResponse(let recipes):
                        completionHandler(.success(recipes))
                    case .notConnectedToInternet:
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    case .networkConnectionLost(_):
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    }
                case .failure(let error):
                    let interactionError = InteractionError(error: error)
                    completionHandler(.failure(interactionError))
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
    }
    
    public func getRecipe(recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, InteractionError>) -> ()) {
        let httpExchange = api.version1.getRecipeHttpExchange(recipeId: recipeId)
        do {
            let dataTask = try session.httpExchangeDataTask(httpExchange) { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .parsedResponse(let recipes):
                        completionHandler(.success(recipes))
                    case .notConnectedToInternet:
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    case .networkConnectionLost(_):
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    }
                case .failure(let error):
                    let interactionError = InteractionError(error: error)
                    completionHandler(.failure(interactionError))
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
    }
   
    public func updateRecipe(updatingRecipe: UpdatingRecipe, completionHandler: @escaping (Result<UpdateRecipeResult, InteractionError>) -> ()) {
        let httpExchange = api.version1.updateRecipeHttpExchange(updatingRecipe: updatingRecipe)
        do {
            let dataTask = try session.httpExchangeDataTask(httpExchange) { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .parsedResponse(let recipes):
                        completionHandler(.success(recipes))
                    case .notConnectedToInternet:
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    case .networkConnectionLost(_):
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    }
                case .failure(let error):
                    let interactionError = InteractionError(error: error)
                    completionHandler(.failure(interactionError))
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
    }
    
    public func deleteRecipe(recipeId: String, completionHandler: @escaping (InteractionError?) -> ()) {
        let httpExchange = api.version1.deleteRecipeHttpExchange(recipeId: recipeId)
        do {
            let dataTask = try session.httpExchangeDataTask(httpExchange) { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .parsedResponse:
                        completionHandler(nil)
                    case .notConnectedToInternet:
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(error)
                    case .networkConnectionLost(_):
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(error)
                    }
                case .failure(let error):
                    let interactionError = InteractionError(error: error)
                    completionHandler(interactionError)
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(.unexpectedError(error: error))
            return
        }
    }
    
    public func addNewRating(addingRating: AddingRating, completionHandler: @escaping (Result<AddedRating, InteractionError>) -> ()) {
        let httpExchange = api.version1.addNewRatingHttpExchange(addingRating: addingRating)
        do {
            let dataTask = try session.httpExchangeDataTask(httpExchange) { result in
                switch result {
                case .success(let result):
                    switch result {
                    case .parsedResponse(let recipes):
                        completionHandler(.success(recipes))
                    case .notConnectedToInternet:
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    case .networkConnectionLost(_):
                        let error = InteractionError.notConnectedToInternet
                        completionHandler(.failure(error))
                    }
                case .failure(let error):
                    let interactionError = InteractionError(error: error)
                    completionHandler(.failure(interactionError))
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
    }

}
