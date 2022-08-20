//
//  AddingRating.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 08.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct AddingRating {
    
    public let recipeId: String
    public let score: Float

    public init(recipeId: String, score: Float) {
        self.recipeId = recipeId
        self.score = score
    }
    
}
