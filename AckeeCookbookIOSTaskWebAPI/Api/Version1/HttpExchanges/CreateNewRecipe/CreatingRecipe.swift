//
//  CreatingRecipe.swift
//  AckeeCookbookIOSTaskWebApi
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct CreatingRecipe {
    
    public let name: String
    public let description: String
    public let ingredients: [String]
    public let duration: Int
    public let info: String

    public init(name: String, description: String, ingredients: [String], duration: Int, info: String) {
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.duration = duration
        self.info = info
    }
    
}
