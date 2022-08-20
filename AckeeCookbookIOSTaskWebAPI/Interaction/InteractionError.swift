//
//  ApiInteractionError.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 08.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public enum InteractionError: Error {
    case notConnectedToInternet
    case unexpectedError(error: Error)
    
    init(error: Error) {
        if (error as NSError).code == NSURLErrorNotConnectedToInternet {
            self = .notConnectedToInternet
        } else {
            self = .unexpectedError(error: error)
        }
    }
    
}
