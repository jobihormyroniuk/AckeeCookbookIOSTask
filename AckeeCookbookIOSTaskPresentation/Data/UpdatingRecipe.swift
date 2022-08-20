//
//  UpdatingRecipe.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 08.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct UpdatingRecipe {
    public let id: String
    public let name: String
    public let duration: Int
    public let description: String
    public let info: String
    public let ingredients: [String]

    init(id: String, name: String, duration: Int, description: String, info: String, ingredients: [String]) {
        self.id = id
        self.name = name
        self.duration = duration
        self.description = description
        self.info = info
        self.ingredients = ingredients
    }
}
