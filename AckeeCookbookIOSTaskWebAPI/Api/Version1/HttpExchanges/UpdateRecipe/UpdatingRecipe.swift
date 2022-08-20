//
//  UpdatingRecipe.swift
//  AckeeCookbookIOSTaskWebApi
//
//  Created by Ihor Myroniuk on 26.04.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct UpdatingRecipe {
    
    public let recipeId: String
    public let name: String
    public let duration: Int
    public let description: String
    public let info: String
    public let ingredients: [String]

    public init(recipeId: String, name: String, duration: Int, description: String, info: String, ingredients: [String]) {
        self.recipeId = recipeId
        self.name = name
        self.duration = duration
        self.description = description
        self.info = info
        self.ingredients = ingredients
    }
    
}
