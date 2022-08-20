//
//  AddedNewRating.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 08.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct AddedRating {
    
    public let id: String
    public let recipeId: String
    public let score: Float
    
    init(id: String, recipeId: String, score: Float) {
        self.id = id
        self.recipeId = recipeId
        self.score = score
    }
    
}
